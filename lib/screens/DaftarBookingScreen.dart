import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/model/OrderUser/OrderModel.dart';
import '../extensions/DateExtension.dart';
import '../template/DaftarBooking/CalendarWidget.dart';
import '../template/DaftarBooking/HeaderLapWidget.dart';
import '../template/DaftarBooking/TableWidget.dart';
import '../model/Paket/PaketModel.dart';
import '../model/OrderUser/TimePesanModel.dart';
import 'package:reservation/screens/BookingListScreen.dart';

class DaftarBookingScreen extends StatefulWidget {
  @override
  _DaftarBookingScreenState createState() => _DaftarBookingScreenState();
}

class _DaftarBookingScreenState extends State<DaftarBookingScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<PaketModel> listPaket = [PaketModel('', 0, [], [], [])];
  List<OrderModel> allOrder = [];
  List<OrderModel> orders = [];
  int indexPaket = 0;
  bool load = true;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List time = [];
  List<TimePesanModel> listTime = [];

  @override
  void initState() {
    super.initState();
    Future.wait([getPaket(), setTime(), getAllOrder()]).then((value) {
      setOrder();
      setState(() {
        this.load = false;
      });
    });
    // setTime();
    // getPaket();
    // getAllOrder();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getAllOrder() async {
    List<OrderModel> orders = [];
    OrderModel order;
    QuerySnapshot qs;
    try {
      qs = await firestore.collection('orders').get();
    } catch (e) {
      throw "Terjadi error,silahkan coba lagi nanti";
    }
    await Future.forEach(qs.docs, (QueryDocumentSnapshot el) {
      try {
        order = OrderModel.fromJson(el, el.id);
        orders.add(order);
      } catch (e) {
        print(e);
      }
    });
    setState(() {
      this.allOrder = orders;
    });
  }

  Future<void> getPaket() async {
    List<PaketModel> listPaket = [];
    PaketModel paket;
    QuerySnapshot qs;
    try {
      qs = await firestore.collection('daftar_harga').get();
    } catch (e) {
      return;
    }
    await Future.forEach(qs.docs, (element) {
      try {
        paket = PaketModel.fromJson(element);
        listPaket.add(paket);
      } catch (e) {}
    });

    setState(() {
      this.listPaket = listPaket;
    });
  }

  Future<void> setTime() async {
    String ket;
    int start, finish;
    List<TimePesanModel> time = [];
    for (int i = 8; i < 25; i++) {
      start = i;
      finish = i + 1;
      ket = TimePesanModel.makeKet(start, finish);
      time.add(TimePesanModel(start, finish, ket));
    }
    setState(() {
      this.listTime = time;
    });
  }

  void setOrder() {
    List<OrderModel> orders = filterOrder(this._selectedDay, this.indexPaket);
    setState(() {
      this.orders = orders;
    });
  }

  void setJenis(int index) {
    if (index != indexPaket) {
      List<OrderModel> orders = filterOrder(this._selectedDay, index);
      setState(() {
        this.indexPaket = index;
        this.orders = orders;
        // this.listTime = setTimeWithOrder(orders);
      });
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!selectedDay.isSameDate(_selectedDay)) {
      List<OrderModel> orders = filterOrder(selectedDay, this.indexPaket);
      setState(() {
        this._focusedDay = focusedDay;
        this._selectedDay = selectedDay;
        this.orders = orders;
        // this.listTime = setTimeWithOrder(orders);
      });
    }
  }

  List<TimePesanModel> setTimeWithOrder(List<OrderModel> orders) {
    List<TimePesanModel> listTime = this.listTime;
    List<OrderModel> o;

    listTime = listTime.map((tpm) {
      o = [];
      o = OrderModel.findWithTimeAndLap(tpm.start, tpm.finish, orders);
      tpm.orders = o;
      return tpm;
    }).toList();
    return listTime;
  }

  List<OrderModel> filterOrder(DateTime select, int index) {
    PaketModel paket = this.listPaket[index];
    String jenis = paket.jenis;
    return this
        .allOrder
        .where((el) => el.jenis == jenis && el.waktu.isSameDate(select))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    int lenP = this.listPaket.length;
    return Scaffold(
      backgroundColor: Color(0xff214C71),
      appBar: AppBar(
          elevation: 0,
          title: Text('Jadwal'),
          backgroundColor: Color(0xff214C71)),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 18, right: 18, bottom: 20),
            child: CalendarWidget(
              callback: onDaySelected,
              selected: this._selectedDay,
              focused: _focusedDay,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding:
                  EdgeInsets.only(top: 35, right: 18, left: 18, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: load
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: List.generate(
                              lenP,
                              (index) {
                                return HeaderLapWidget(
                                  index: index,
                                  length: lenP,
                                  text: this.listPaket[index].jenis,
                                  choose: index == indexPaket,
                                  callback: () => setJenis(index),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: TableWidget(
                                paket: this.listPaket[indexPaket],
                                listTime: this.listTime,
                                orders: this.orders,
                                event: (List<OrderModel> data) async {
                                  final route = MaterialPageRoute(
                                    builder: (context) =>
                                        BookingListScreen(data),
                                  );
                                  await Navigator.of(context).push(route);
                                  List<OrderModel> oldData = this.orders;
                                  // oldData = oldData.map((e) {
                                  //   int i =
                                  //       data.indexWhere((el) => el.id == e.id);
                                  //   if (i != -1) {
                                  //     e.dp = data[i].dp;
                                  //   }
                                  //   return e;
                                  // }).toList();
                                  setState(() {
                                    this.orders = oldData;
                                  });
                                  // setState((){

                                  // })

                                  // print(data.first.id);
                                  // print(data.first.dp);

                                  // final route = MaterialPageRoute(
                                  //   builder: (context) =>
                                  //       BookingListScreen(data),
                                  // );
                                  // final a =
                                  //     await Navigator.of(context).push(route);
                                  // // print(a);
                                  // if (data.isNotEmpty) {
                                  //   OrderModel a = data.first;
                                  //   int ind = this.orders.indexWhere(
                                  //       (element) => element.id == a.id);
                                  //   if (ind != -1) {
                                  //     print('dbs');
                                  //     print(this.orders[ind].id);
                                  //     print(this.orders[ind].dp);
                                  //   }
                                  // }
                                  // print
                                  // print(data);
                                  // List<OrderModel> orders = this.allOrder;
                                  // orders = orders.map((e) {
                                  //   int indexFound =
                                  //       data.indexWhere((el) => el.id == e.id);
                                  //   if (indexFound != -1) {
                                  //     e.dp = data[indexFound].dp;
                                  //   }
                                  //   return e;
                                  // }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          )
          // Container()
        ],
      ),
    );
  }
}
