import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import '../model/OrderLapangan/DataOrderModel.dart';
import '../extensions/DateExtension.dart';
import '../template/OrderLap/ChoosePaket.dart';
import '../model/PaketLapangan/JenisPaketModel.dart';
import '../model/PaketLapangan/PaketModel.dart';
import '../model/PaketLapangan/TimePaketModel.dart';
import '../model/OrderLapangan/OrderModel.dart';
import '../model/OrderLapangan/TimePesanModel.dart';
import '../template/OrderLap/ChooseDate.dart';
import '../template/OrderLap/ChooseTime.dart';

class OrderLapScreen extends StatefulWidget {
  final String? title;
  OrderLapScreen({Key? key, @required this.title}) : super(key: key);
  @override
  _OrderLapScreenState createState() => _OrderLapScreenState();
}

class _OrderLapScreenState extends State<OrderLapScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  PaketModel paket = PaketModel('', 0, 0, [], []);
  List<JenisPaketModel> daftarHarga = [];
  int harga = 0;
  List<DateTime> dateList = [];
  int index = 0;
  bool first = true;
  List<OrderModel> ordersWithDate = [];
  OrderModel? order;
  List<TimePesanModel> timePesan = [];
  bool load = true;
  bool errorScreen = false;
  @override
  void initState() {
    DateTime now = DateTime.now();
    List<DateTime> date = [];
    date.add(now);
    for (int i = 1; i < 14; i++) {
      date.add(now.add(Duration(days: i)));
    }

    setState(() {
      dateList = date;
    });
    super.initState();

    Future.wait([getAllOrder(now), getDaftarHarga(now)]).then((value) {
      Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
            load = false;
          }));
    }, onError: (Object e, StackTrace stackTrace) {
      setState(() {
        errorScreen = true;
      });
      print(e);
    });
  }

  void dispose() {
    super.dispose();
  }

  Future<bool> getDaftarHarga(DateTime now) async {
    try {
      String day = DateFormat('E').format(now);
      if (day == 'Fri') {
        day = 'jumat';
      } else if (day == 'Sat' || day == 'Sun') {
        day = 'sabtu';
      } else {
        day = 'senin';
      }
      QuerySnapshot qs = await firestore
          .collection('daftar_harga')
          .where('field', isEqualTo: widget.title?.toLowerCase())
          .get();

      if (qs.docs.length == 1) {
        List<JenisPaketModel> daftarHarga = [];
        QueryDocumentSnapshot doc = qs.docs[0];
        PaketModel paket = PaketModel.fromJson(doc);
        await Future.forEach(paket.paketList, (JenisPaketModel element) {
          if (element.hari == day) daftarHarga.add(element);
        });

        setState(() {
          index = 0;
          this.daftarHarga = daftarHarga;
          this.paket = paket;
        });
      }
      return true;
    } catch (error) {
      print(error);
      throw '';
    }
  }

  Future<void> getAllOrder(DateTime now) async {
    now = now.subtract(Duration(
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond,
      microseconds: now.microsecond,
    ));
    try {
      DateTime end = now.add(Duration(days: 13));
      QuerySnapshot qs = await firestore
          .collection('orders')
          .where('field', isEqualTo: widget.title?.toLowerCase())
          .where('waktu', isGreaterThanOrEqualTo: now)
          .where('waktu', isLessThanOrEqualTo: end)
          .get();
      List<OrderModel> orderList = [];
      int indexFound;
      DateTime waktu;
      List time;
      List<DataOrderModel> listdom;
      await Future.forEach(qs.docs, (QueryDocumentSnapshot element) {
        listdom = [];
        waktu = element['waktu'].toDate();
        time = element['pesanan'];
        indexFound = orderList.indexWhere((el) => el.tanggal.isSameDate(waktu));
        for (int i = 0; i < time.length; i++) {
          listdom.add(DataOrderModel(
            element.id,
            element['lap'],
            element['biaya'],
            time[i]['start'],
            time[i]['finish'],
            element['batas'].toDate(),
          ));
        }
        if (indexFound == -1) {
          OrderModel order =
              OrderModel(new DateTime(waktu.year, waktu.month, waktu.day), '');
          order.mergeDataOrder(listdom);
          orderList.add(order);
        } else {
          orderList[indexFound].mergeDataOrder(listdom);
        }
      });
      var o = orderList.where((element) => element.tanggal.isSameDate(now));
      setState(() {
        this.ordersWithDate = orderList;
        this.order = o.isNotEmpty ? o.first : null;
      });
    } catch (err) {
      throw '';
    }
  }

  Future<void>? setHari(int index) async {
    if (this.load) return null;
    try {
      // final loc = tz.getLocation('Indonesia/Jakarta');
      // tz.TZDateTime nowNY = tz.TZDateTime.now(loc);
      DateTime date = dateList[index];
      String day = DateFormat('E').format(date);
      if (day == 'Fri')
        day = 'jumat';
      else if (day == 'Sat' || day == 'Sun')
        day = 'sabtu';
      else
        day = 'senin';

      List<JenisPaketModel> daftarHarga =
          this.paket.paketList.where((element) => element.hari == day).toList();

      var o = this
          .ordersWithDate
          .where((element) => element.tanggal.isSameDate(date));

      setState(() {
        this.daftarHarga = daftarHarga;
        this.index = index;
        this.first = true;
        this.order = o.isEmpty ? null : o.first;
      });
      // bool l = (tpm.start > e.start &&
      //                 tpm.finish > e.finish &&
      //                 tpm.start < e.finish) ||
      //             (tpm.start < e.start &&
      //                 tpm.finish < e.finish &&
      //                 tpm.finish > e.start) ||
      //             (tpm.start == e.start && tpm.finish > e.finish) ||
      //             (tpm.start < e.start && tpm.finish == e.finish) ||
      //             (tpm.start == e.start && tpm.finish == e.finish) ||
      //             (tpm.start < e.start && tpm.finish > e.finish);
    } catch (e) {
      print(e);
    }
  }

  Future<void> setHarga(String tipe, String waktu) async {
    var foundDaftarHarga = this
        .daftarHarga
        .where((element) => element.tipe == tipe && element.waktu == waktu);
    if (foundDaftarHarga.isNotEmpty) {
      DateTime now = DateTime.now();
      List<DataOrderModel> orders = this.order?.orderData ?? [];
      orders =
          orders.where((el) => el.batas.difference(now).inMinutes > 0).toList();

      int start, finish;
      String ket;
      List<TimePesanModel> timePesan = [];
      TimePesanModel tpm;
      if (tipe == 'reguler') {
        int i = waktu == 'siang' ? 8 : 16;
        int max = waktu == 'siang' ? 16 : 25;
        while (i < max) {
          start = i;
          finish = i + 1;
          ket = (start == 24 ? 0 : start).toString().padLeft(2, '0') +
              '.00 - ' +
              (finish > 23 ? finish - 24 : finish).toString().padLeft(2, '0') +
              '.00';
          tpm = TimePesanModel(
            start,
            finish,
            ket,
          );
          var found = orders.where((order) {
            bool d = (tpm.start >= order.start && order.finish >= tpm.finish);
            // if(d && order.bayar)
            return d;
          }).toList();
          if (found.length > 2) {
            tpm.canOrder = false;
          }
          await Future.forEach(
              found, (DataOrderModel e) => tpm.addLapUsed(e.lap));
          timePesan.add(tpm);
          i++;
        }
      } else {
        List<TimePaketModel> times = this.paket.timeList;
        for (int i = 0; i < times.length; i++) {
          if (times[i].waktu == waktu) {
            start = times[i].start;
            finish = times[i].finish;
            ket = (start == 24 ? 0 : start).toString().padLeft(2, '0') +
                '.00 - ' +
                (finish > 23 ? finish - 24 : finish)
                    .toString()
                    .padLeft(2, '0') +
                '.00';
            tpm = TimePesanModel(
              start,
              finish,
              ket,
            );
            var found = orders.where((order) {
              bool d = (tpm.start <= order.start &&
                      tpm.finish <= order.finish &&
                      this.paket.paket > (order.start - tpm.start)) ||
                  (tpm.start >= order.start &&
                      tpm.finish >= order.finish &&
                      this.paket.paket > (tpm.start - order.start));
              return d;
            });
            if (found.length > 2) {
              tpm.canOrder = false;
            }
            await Future.forEach(
                found.toList(), (DataOrderModel el) => tpm.addLapUsed(el.lap));

            timePesan.add(tpm);
          }
        }
        // timePesan.sort((a, b) => a.start.compareTo(b.start));
      }

      // DataOrderModel dom;
      // for (int j = 0; j < orders.length; j++) {
      //   dom = orders[j];
      //   if (dom.batas.difference(now).inMinutes < 0) continue;
      //   for (int i = 0; i < timePesan.length; i++) {
      //     tpm = timePesan[i];
      //     dom = orders[j];
      //     bool d = false;
      //     if (tipe == 'reguler') {
      //       d = (tpm.start >= dom.start && dom.end >= tpm.finish);
      //     } else {
      //       d = (tpm.start <= dom.start &&
      //               tpm.finish <= dom.end &&
      //               this.paket.paket > (dom.start - tpm.start)) ||
      //           (tpm.start >= dom.start &&
      //               tpm.finish >= dom.end &&
      //               this.paket.paket > (tpm.start - dom.start));
      //     }
      //     if (d) {
      //       tpm.canOrder = false;
      //     }
      //   }
      // }
      setState(() {
        this.timePesan = timePesan;
        this.first = false;
        this.harga = foundDaftarHarga.first.harga;
      });
    }
  }

  Future<void> chooseOrder(int index) async {
    List<TimePesanModel> tp = this.timePesan;
    tp[index].choose = tp[index].choose ? false : true;
    DateTime now = DateTime.now().add(Duration(hours: 2));
    bool d = DateTime.now().isSameDate(this.dateList[this.index]);
    tp = tp.map((e) {
      if (d && e.start < now.hour) e.canOrder = e.choose = false;
      return e;
    }).toList();
    setState(() {
      this.timePesan = tp;
    });
  }

  String formatCurrency(String tipe, String waktu) {
    var currency = new NumberFormat("#,##0.00", "pt_BR");
    Iterable<JenisPaketModel> j =
        this.daftarHarga.where((el) => el.tipe == tipe && el.waktu == waktu);
    int harga = 0;
    if (j.isNotEmpty) harga = j.first.harga;
    return currency.format(harga).split(',')[0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff214C71),
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title ?? ''),
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
                ChooseDate(this.dateList, this.index, (i) => setHari(i)),
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
              child: errorScreen
                  ? Center(
                      child: Text(
                        "Terjadi error Silahkan Coba lagi nanti",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    )
                  : load
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
                                          onTap: () =>
                                              setHarga("reguler", "siang"),
                                          child: ChoosePaket(
                                            size: (size.width - 36) / 2 - 15,
                                            ket: '08.00 - 16.00',
                                            title: 'SIANG',
                                            harga:
                                                'Rp. ${formatCurrency("reguler", "siang")}',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              setHarga("reguler", "malam"),
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
                                    margin:
                                        EdgeInsets.only(bottom: 10, top: 10),
                                    child: Text(
                                      'Paket ${this.paket.paket} jam',
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
                                          onTap: () =>
                                              setHarga("paket", "siang"),
                                          child: ChoosePaket(
                                            size: (size.width - 36) / 2 - 15,
                                            ket: '08.00 - 16.00',
                                            title: 'SIANG',
                                            harga:
                                                'Rp. ${formatCurrency('paket', "siang")}',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              setHarga("paket", "malam"),
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
                              data: [],
                              callback: chooseOrder,
                              callback2: () {
                                this.timePesan.forEach((element) {
                                  print(element.start);
                                  print(element.choose);
                                });
                              },
                              dateIsSame:
                                  DateTime.now().isSameDate(dateList[index]),
                            ),
            ),
          )
        ],
      ),
    );
  }
}
