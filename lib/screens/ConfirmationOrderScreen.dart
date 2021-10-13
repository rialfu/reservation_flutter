import 'package:flutter/material.dart';
import 'package:reservation/extensions/MSP.dart';
import 'package:reservation/model/OrderUser/OrderModel.dart';
import 'package:reservation/model/OrderUser/PesananModel.dart';
import 'package:reservation/model/OrderUser/TimePesanModel.dart';
import 'package:reservation/services/UserRepository.dart';
import 'package:provider/provider.dart';
import 'package:reservation/extensions/StringExtension.dart';
import 'package:reservation/template/Countdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/extensions/DateExtension.dart';
import 'package:reservation/extensions/OpenApp.dart';

class ConfirmationOrderScreen extends StatefulWidget {
  final OrderModel order;
  ConfirmationOrderScreen({required this.order});
  @override
  _ConfirmationOrderScreenState createState() =>
      _ConfirmationOrderScreenState();
}

class _ConfirmationOrderScreenState extends State<ConfirmationOrderScreen>
    with TickerProviderStateMixin {
  late OrderModel order;
  late AnimationController _controller;
  bool load = false;
  bool first = true;
  int time = 1800;
  String id = '';
  String hari = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: time,
      ), // gameData.levelClock is a user entered number elsewhere in the applciation
    );
    order = widget.order;
    super.initState();
  }

  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<void> process(BuildContext context) async {
    final user = Provider.of<UserRepository>(context, listen: false);
    String userId = user.user?.uid ?? '';
    if (userId == '') return;
    DateTime now = DateTime.now();
    OrderModel order = this.order;
    order.userId = userId;
    order.batas = now.add(Duration(seconds: this.time));
    Map<String, dynamic> data = order.toSaveFireStore();
    String id = now.year.toString() + now.month.toString() + now.day.toString();
    // order.waktu;
    id = id + StringMa.randomString();
    try {
      await firestore.collection('orders').doc(id).set(data);
      setState(() {
        first = false;
        this.id = id;
        this.hari = order.waktu.convertDate();
      });

      _controller.forward();
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
          content: Text(
        'gagal menyimpan, silahkan coba lagi nanti',
        style: TextStyle(fontSize: 17),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // await firestore.collection('orders').
    // _controller.forward();
  }

  void openWhatsapp(BuildContext context) async {
    try {
      await OpenApp.whatsapp(this.id, this.hari);
    } catch (e) {
      var sb = SnackBar(content: new Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    Size size = MediaQuery.of(context).size;
    // Consumer()
    return WillPopScope(
      onWillPop: () async {
        if (id != '') {
          Navigator.popUntil(context, (route) => route.isFirst);
          return true;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xff214C71),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(22, 25, 22, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: size.width * 0.85,
            height: size.height,
            constraints: BoxConstraints(maxHeight: size.height * 0.6),
            child: first
                ? Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            setForm('Nama',
                                (user.userData?.name ?? '').capFirstofEach),
                            setForm('Jenis', widget.order.jenis.firstChar),
                            setForm('Harga', widget.order.harga.toString()),
                            setForm('DP',
                                (widget.order.harga / 2).toStringAsFixed(0)),
                            Column(
                              children: List.generate(
                                  widget.order.listPesanan.length, (index) {
                                PesananModel pesanan =
                                    widget.order.listPesanan[index];
                                String keterangan = TimePesanModel.makeKet(
                                    pesanan.start, pesanan.finish);

                                return setForm(index == 0 ? 'Ket' : '',
                                    keterangan + ' Lap ' + pesanan.lap);
                              }),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                padding: MSP.jarak(18, 8, 18, 8),
                                backgroundColor: MSP.color(Colors.grey[400]),
                                shape: MSP.rectangle(18),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                padding: MSP.jarak(18, 8, 18, 8),
                                backgroundColor: MSP.color(Colors.blue[300]),
                                shape: MSP.rectangle(10),
                              ),
                              onPressed: () => process(context),
                              child: Text("Konfirmasi",
                                  style: TextStyle(fontSize: 25)),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Menunggu Pembayaran",
                              style: TextStyle(fontSize: 17),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Image.asset(
                                'image/sand-clock.png',
                                height:
                                    MediaQuery.of(context).size.width * 0.12,
                                width: MediaQuery.of(context).size.width * 0.12,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Countdown(
                              animation: StepTween(
                                begin: time, // THIS IS A USER ENTERED NUMBER
                                end: 0,
                              ).animate(_controller),
                              fontSize: 30,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                  child: Text(
                                    "NT : Kirimkan bukti Pembayaran dan bukti booking melalui whatsapp",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MSP.size(size.width * 0.5, 30),
                                    padding: MSP.jarak(18, 8, 18, 8),
                                    backgroundColor:
                                        MSP.color(Colors.green[400]),
                                    shape: MSP.rectangle(10),
                                  ),
                                  onPressed: () => openWhatsapp(context),
                                  child: Text(
                                    "Link WhatsApp",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MSP.size(size.width * 0.5, 30),
                                    padding: MSP.jarak(18, 8, 18, 8),
                                    backgroundColor:
                                        MSP.color(Colors.grey[350]),
                                    shape: MSP.rectangle(10),
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                                  child: Text(
                                    "Tutup",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget setForm(String ket, String val, {double fontSize = 20}) {
    final ts = TextStyle(
      fontSize: fontSize,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 1),
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ket, style: ts),
              Text(':', style: ts),
            ],
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(val, style: ts, overflow: TextOverflow.visible),
          ),
        ),
      ],
    );
  }
}
