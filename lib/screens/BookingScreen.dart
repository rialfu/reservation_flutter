import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../extensions/DateExtension.dart';
import '../model/Paket/PaketModel.dart';
import '../model/Paket/TimePaketModel.dart';
import 'package:reservation/screens/ConfirmationOrderScreen.dart';
import '../model/OrderUser/OrderModel.dart';
import '../model/OrderUser/PesananModel.dart';
import '../model/OrderUser/TimePesanModel.dart';
import '../template/OrderLap/ChooseDate.dart';
import '../template/OrderLap/ChoosePaket.dart';
import '../template/OrderLap/ChooseTime1.dart';

class BookingScreen extends StatefulWidget {
  final String title;
  BookingScreen({required this.title});
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool load = true;
  bool first = true;
  List<DateTime> dateList = [];
  List<TimePesanModel> listTime = [];
  int indexDate = 0;
  PaketModel paket = PaketModel('', 0, [], [], []);
  List<OrderModel> orders = [];
  int harga = 0;

  @override
  void initState() {
    super.initState();
    List<DateTime> dateList = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 14; i++) {
      dateList.add(now.add(Duration(days: i)));
    }
    setState(() {
      this.dateList = dateList;
    });
    Future.wait([getPaket(), getOrder()]).then((value) {
      setState(() {
        this.load = false;
      });
    });
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getPaket() async {
    try {
      QuerySnapshot qs = await firestore
          .collection('daftar_harga')
          .where('jenis', isEqualTo: widget.title.toLowerCase())
          .limit(1)
          .get();
      if (qs.docs.length == 1) {
        var data = qs.docs[0];
        PaketModel paket = PaketModel.fromJson(data);
        setState(() {
          this.paket = paket;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getOrder() async {
    DateTime now = DateTime.now();
    now = now.subtract(Duration(
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond,
      microseconds: now.microsecond,
    ));
    List<OrderModel> orders = [];
    OrderModel order;
    try {
      QuerySnapshot qs = await firestore
          .collection('orders')
          .where('jenis', isEqualTo: widget.title.toLowerCase())
          .where('waktu', isGreaterThanOrEqualTo: now)
          .where('waktu', isLessThan: now.add(Duration(days: 14)))
          .get();
      await Future.forEach(qs.docs, (QueryDocumentSnapshot el) {
        order = OrderModel.fromJson(el, el.id);
        orders.add(order);
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      this.orders = orders;
    });
  }

  void setHari(int index) async {
    setState(() {
      this.indexDate = index;
      this.first = true;
    });
  }

  String formatCurrency(String tipe, String waktu) {
    DateTime date = this.dateList[this.indexDate];
    String day = DateFormat('E').format(date);
    var currency = new NumberFormat("#,##0.00", "pt_BR");
    int harga = getHarga(tipe, waktu, day);

    return currency.format(harga).split(',')[0];
  }

  int getHarga(String tipe, String waktu, String day) {
    int harga = 0;
    if (day == 'Fri')
      day = 'jumat';
    else if (day == 'Sat' || day == 'Sun')
      day = 'sabtu';
    else
      day = 'senin';

    var j = this
        .paket
        .hpm
        .where((e) => e.tipe == tipe && e.waktu == waktu && e.hari == day);

    if (j.isNotEmpty) harga = j.first.harga;
    return harga;
  }

  Future<void> setPaket(String tipe, String waktu) async {
    DateTime date = this.dateList[this.indexDate];
    DateTime now = DateTime.now();
    bool first = true;
    List<OrderModel> orders = this
        .orders
        .where((e) =>
            e.batas.difference(now).inMinutes > 0 && e.waktu.isSameDate(date))
        .toList();

    List<PesananModel> listPesanan =
        orders.expand((element) => element.listPesanan).toList();
    int start, finish;
    String ket;
    TimePesanModel tpm;
    List<TimePesanModel> listTime = [];
    String day = DateFormat('E').format(date);
    int harga = getHarga(tipe, waktu, day);
    try {
      if (tipe == 'reguler') {
        int i = waktu == 'siang' ? 8 : 16;
        int max = waktu == 'siang' ? 16 : 25;
        int lenLap = this.paket.listLap.length;
        while (i < max) {
          start = i;
          finish = i + 1;
          ket = TimePesanModel.makeKet(start, finish);
          tpm = TimePesanModel(start, finish, ket);

          var found = listPesanan.where((e) {
            bool d = (tpm.start >= e.start && e.finish >= tpm.finish);
            // print([tpm.start, tpm.finish, e.start, e.finish, d]);
            return d;
          }).toList();
          if (found.length >= lenLap) tpm.canOrder = false;
          tpm.pesanan = found;
          listTime.add(tpm);
          i++;
        }
      } else {
        int lenLap = this.paket.listLap.length;
        await Future.forEach(this.paket.tpm, (TimePaketModel el) {
          if (el.waktu == waktu) {
            start = el.start;
            finish = el.finish;
            ket = TimePesanModel.makeKet(start, finish);
            tpm = TimePesanModel(start, finish, ket);

            var found = listPesanan.where((e) {
              bool j = !((tpm.start > e.start && tpm.start >= e.finish) ||
                  (tpm.finish < e.finish && tpm.finish <= e.start));
              // print([tpm.start, tpm.finish, e.start, e.finish, j]);
              return j;
            }).toList();
            List<Map<String, dynamic>> maps = [];
            found.forEach((element) {
              var j = maps.indexWhere((e) => e['lap'] == element.lap);
              if (j == -1)
                maps.add({'lap': element.lap, 'count': 1});
              else
                maps[j]['count'] = maps[j]['count'] + 1;
            });
            if (found.length >= lenLap) tpm.canOrder = false;
            tpm.pesanan = found;
            listTime.add(tpm);
          }
        });
      }
      first = false;
    } catch (e) {}

    setState(() {
      this.listTime = listTime;
      this.harga = harga;
      this.first = first;
    });
  }

  void process(List<PesananModel> list) {
    DateTime date = this.dateList[this.indexDate];
    date = date.subtract(Duration(
      hours: date.hour,
      minutes: date.minute,
      seconds: date.second,
      milliseconds: date.millisecond,
      microseconds: date.microsecond,
    ));
    OrderModel order = OrderModel.makeTemplate(
      this.paket.jenis,
      date,
      list,
      this.harga * list.length,
    );
    final route = MaterialPageRoute(
      builder: (context) => ConfirmationOrderScreen(order: order),
    );
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff214C71),
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
        backgroundColor: Color(0xff214C71),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pilih Tanggal",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                ChooseDate(this.dateList, this.indexDate, setHari),
              ],
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
                  topRight: Radius.circular(30),
                ),
              ),
              child: load
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : first
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Reguler",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => setPaket("reguler", "siang"),
                                      child: ChoosePaket(
                                        size: (size.width - 36) / 2 - 15,
                                        ket: '08.00 - 16.00',
                                        title: 'SIANG',
                                        harga:
                                            'Rp. ${formatCurrency("reguler", "siang")}',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setPaket("reguler", "malam"),
                                      child: ChoosePaket(
                                        size: (size.width - 36) / 2 - 15,
                                        ket: '16.00 - 01.00',
                                        title: 'MALAM',
                                        harga:
                                            'Rp. ${formatCurrency("reguler", "malam")}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10, top: 10),
                                child: Text(
                                  'Paket ${this.paket.long} jam',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => setPaket("paket", "siang"),
                                      child: ChoosePaket(
                                        size: (size.width - 36) / 2 - 15,
                                        ket: '08.00 - 16.00',
                                        title: 'SIANG',
                                        harga:
                                            'Rp. ${formatCurrency('paket', "siang")}',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setPaket("paket", "malam"),
                                      child: ChoosePaket(
                                        size: (size.width - 36) / 2 - 15,
                                        ket: '16.00 - 01.00',
                                        title: 'MALAM',
                                        harga:
                                            'Rp. ${formatCurrency('paket', "malam")}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ChooseTime(
                          data: this.listTime,
                          callback: process,
                          date: this.dateList[this.indexDate],
                          listLap: this.paket.listLap,
                        ),
            ),
          )
        ],
      ),
    );
  }
}
