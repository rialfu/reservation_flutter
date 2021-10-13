import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/model/OrderUser/OrderModel.dart';
import 'package:reservation/model/OrderUser/PesananModel.dart';
import 'package:reservation/model/OrderUser/TimePesanModel.dart';
import 'package:reservation/services/UserRepository.dart';
import 'package:provider/provider.dart';
import 'package:reservation/extensions/DateExtension.dart';
import 'package:reservation/extensions/MSP.dart';
import 'package:reservation/extensions/OpenApp.dart';

class MyBookingListScreen extends StatefulWidget {
  @override
  _MyBookingListScreenState createState() => _MyBookingListScreenState();
}

class _MyBookingListScreenState extends State<MyBookingListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<OrderModel> orders = [];
  bool load = false;
  void initState() {
    // WidgetsBinding.instance.
    super.initState();
    getOrder();
  }

  Future<void> getOrder() async {
    final user = Provider.of<UserRepository>(context, listen: false);
    OrderModel order;
    List<OrderModel> orders = [];
    QuerySnapshot qs;
    try {
      qs = await firestore
          .collection('orders')
          .where('userId', isEqualTo: user.user?.uid ?? '')
          .get();
    } catch (e) {
      print(e);
      return;
    }

    await Future.forEach(qs.docs, (QueryDocumentSnapshot el) {
      try {
        order = OrderModel.fromJson(el, el.id);
        orders.add(order);
      } catch (e) {}
    });
    orders.sort((a, b) => b.waktu.compareTo(a.waktu));
    setState(() {
      this.orders = orders;
    });
  }

  TextStyle textStyle() {
    return TextStyle(fontSize: 17);
  }

  void openWhatsapp(String id, String hari) async {
    try {
      await OpenApp.whatsapp(id, hari);
    } catch (e) {
      var sb = SnackBar(content: new Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  Future<void> openDetail(BuildContext ctx, OrderModel order) async {
    Size size = MediaQuery.of(ctx).size;
    List<PesananModel> p = order.listPesanan;
    String ket;
    Scaffold.of(ctx).showBottomSheet((context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black54, width: 1)),
        ),
        width: size.width,
        height: size.height * 0.5,
        // color: Colors.grey[400],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        child: Text("Close"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Text(
                    "Booking id: " + order.id,
                    style: textStyle(),
                  ),
                  Text(
                    "Jenis: " + order.jenis,
                    style: textStyle(),
                  ),
                  Text(
                    "Harga: " + order.harga.toString(),
                    style: textStyle(),
                  ),
                  Text(
                    "DP: " + (order.dp ? "Sudah" : "Belum"),
                    style: textStyle(),
                  ),
                  Text(
                    "Batas: " + order.batas.convertDate(),
                    style: textStyle(),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: p.length,
                      itemBuilder: (context, index) {
                        ket = TimePesanModel.makeKet(
                            p[index].start, p[index].finish);
                        ket += ' ' + p[index].lap;
                        return Text(
                          ket,
                          style: textStyle(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MSP.size(size.width * 0.5, 30),
                    padding: MSP.jarak(18, 8, 18, 8),
                    backgroundColor: MSP.color(Colors.green[400]),
                    shape: MSP.rectangle(10),
                  ),
                  onPressed: () =>
                      openWhatsapp(order.id, order.waktu.convertDate()),
                  child: Text(
                    "Link WhatsApp",
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => new AlertDialog(
    //     title: new Text('Warning'),
    //     content: new Text('Hi this is Flutter Alert Dialog'),
    //     actions: <Widget>[
    //       new IconButton(
    //           icon: new Icon(Icons.close),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           })
    //     ],
    //   ),
    // );
  }

  // String convertDate(DateTime date) => DateFormat('d MMM yyyy').format(date);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff214C71),
      appBar: AppBar(
        title: Text("My Booking"),
        elevation: 0,
        backgroundColor: Color(0xff214C71),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView.builder(
                  itemCount: this.orders.length,
                  itemBuilder: (context, int index) {
                    OrderModel order = this.orders[index];
                    Color? color;
                    List<String> status;
                    if (order.waktu.difference(DateTime.now()).inMinutes < 0) {
                      color = Colors.grey[700];
                      status = ['Selesai'];
                      // status = 'Selesai';
                    } else if (order.dp == false) {
                      color = Colors.red;
                      status = ['Menunggu', 'Konfirmasi / Bayaran'];
                    } else {
                      color = Colors.blue[300];
                      status = ['Terkonfirmasi'];
                    }

                    return Container(
                      height: 150,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 9),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.jenis.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  status.length,
                                  (index) => Text(status[index]),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.waktu.convertDate(),
                                style: TextStyle(fontSize: 17),
                              ),
                              TextButton(
                                style:
                                    ButtonStyle(padding: MSP.jarak(5, 5, 5, 5)),
                                child: Text(
                                  "Detail",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () => openDetail(context, order),
                              ),
                            ],
                          )
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     SizedBox(
                          //       width: 20,
                          //     ),
                          //     Container(
                          //       width: 150,
                          //       child: Flexible(
                          //         child: Text(status,
                          //             overflow: TextOverflow.visible),
                          //       ),
                          //     ),
                          //   ],
                          // )
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       order.waktu.convertDate(),
                          //       style: TextStyle(fontSize: 17),
                          //     ),
                          //     Container(
                          //       width: 150,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.end,
                          //         children: [
                          //           // width: 50,
                          //           Text(
                          //             status,
                          //           ),

                          //           TextButton(
                          //             child: Text(
                          //               "Detail",
                          //               style: TextStyle(color: Colors.white),
                          //             ),
                          //             onPressed: () =>
                          //                 openDetail(context, order),
                          //           ),
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "No Booking : " + order.id,
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Text(
                      //       "Jenis : " + order.jenis,
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Text(
                      //       "DP : " + (order.dp ? 'Sudah' : "Belum"),
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Text(
                      //       "Batas: " + order.batas.convertDate(),
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Text(
                      //       "Waktu: " + order.waktu.convertDate(),
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Expanded(
                      //       flex: 1,
                      //       child: Stack(
                      //         children: [
                      //           Align(
                      //             alignment: FractionalOffset.bottomRight,
                      //             child: TextButton(
                      //               child: Text(
                      //                 "Detail",
                      //                 style: TextStyle(color: Colors.white),
                      //               ),
                      //               onPressed: () => openDetail(context, order),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
