import 'package:flutter/material.dart';
import 'package:reservation/model/OrderUser/OrderModel.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingListScreen extends StatefulWidget {
  final List<OrderModel> orders;
  BookingListScreen(this.orders);
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<OrderModel> orders = [];
  bool load = false;
  void initState() {
    setState(() {
      this.orders = widget.orders;
    });

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  String convertDate(DateTime date) => DateFormat('d MMM yyyy').format(date);
  // return '';

  TextStyle designText() => TextStyle(fontSize: 16);

  Future<void> process(int index, bool dp) async {
    setState(() {
      load = true;
    });
    List<OrderModel> orders = this.orders;
    String mess = 'Sukses memperbarui data';
    try {
      CollectionReference collection = firestore.collection('orders');
      await collection.doc(orders[index].id).update({'dp': dp});
      orders[index].dp = dp;
      setState(() {
        this.orders = orders;
      });
    } catch (e) {
      mess = "Gagal memperbarui data";
    }
    final snackBar = SnackBar(
      content: Text(mess, style: TextStyle(fontSize: 17)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      load = true;
    });
  }

  Future<void> change(BuildContext context, bool dp, int index) async {
    String ket = dp ? 'Sudah' : 'Belum';
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Anda yakin ingin merubah dp menjadi " + ket),
      actions: [
        cancelButton(context),
        continueButton(context, index, dp),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    // Navigator.pop(context, []);
  }

  Widget cancelButton(BuildContext context) {
    return TextButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Widget continueButton(BuildContext context, int index, bool dp) {
    return TextButton(
      child: Text("Continue"),
      onPressed: () {
        process(index, dp);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff214C71),
      appBar: AppBar(
        title: Text("Pesanana"),
        elevation: 0,
        backgroundColor: Color(0xff214C71),
      ),
      body:
          // WillPopScope(
          //   onWillPop: () {
          //     // Navigator.pop(context, []);
          //     // return true;
          //     return Future.value(true);
          //   },
          //   child:
          Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: ListView.builder(
                  itemCount: this.orders.length,
                  itemBuilder: (context, int index) {
                    OrderModel order = this.orders[index];
                    String date = convertDate(order.batas);
                    bool dp = order.dp;
                    String ketDP = dp ? 'Sudah' : 'Belum';
                    Color bgColor =
                        dp ? Colors.green.shade400 : Colors.red.shade400;
                    print(dp);
                    return GestureDetector(
                      onTap: () => load ? null : change(context, !dp, index),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 9),
                        height: 120,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No Booking:",
                                  style: designText(),
                                ),
                                Text(
                                  this.orders[index].id,
                                  style: designText(),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Batas : ",
                                    style: designText(),
                                  ),
                                  Text(
                                    date,
                                    style: designText(),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "DP: " + ketDP,
                                    style: designText(),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
