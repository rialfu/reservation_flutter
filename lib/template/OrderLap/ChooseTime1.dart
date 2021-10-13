import 'package:flutter/material.dart';
// import '../../model/OrderLapangan/TimePesanModel.dart';
import '../../model/OrderUser/TimePesanModel.dart';
import '../../model/Paket/PaketModel.dart';
import '../../model/OrderUser/PesananModel.dart';
import '../../extensions/DateExtension.dart';

class ChooseTime extends StatefulWidget {
  final List<TimePesanModel> data;
  final DateTime date;
  final Function callback;
  final List<String> listLap;
  ChooseTime({
    required this.data,
    required this.date,
    required this.callback,
    required this.listLap,
  });
  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  List<TimePesanModel> data = [];
  DateTime date = DateTime.now();
  bool isDateSame = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      this.isDateSame = widget.date.isSameDate(DateTime.now());
      this.data = widget.data;
      this.date = widget.date;
    });
  }

  void choose(int index) {
    List<TimePesanModel> tp = this.data;
    tp[index].choose = tp[index].choose ? false : true;
    DateTime now = DateTime.now().add(Duration(hours: 2));
    tp = tp.map((e) {
      if (isDateSame && e.start < now.hour) e.canOrder = e.choose = false;
      return e;
    }).toList();
    setState(() {
      this.data = tp;
    });
  }

  void process() {
    List<TimePesanModel> tp = this.data;
    DateTime now = DateTime.now().add(Duration(hours: 2));
    tp = tp.where((e) {
      if (isDateSame && e.start < now.hour) return false;
      return e.choose;
    }).toList();
    if (tp.isNotEmpty) {
      List<PesananModel> pesanan = [];
      String? lap;
      tp.forEach((e) {
        var j = e.pesanan.map((e) => e.lap).toList();
        if (j.isEmpty)
          lap = widget.listLap.first;
        else
          lap = PaketModel.getDifferent(j, widget.listLap);
        if (lap != null) {
          pesanan.add(PesananModel(e.start, e.finish, lap ?? ''));
        }
      });

      widget.callback(pesanan);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEmp = this.data.where((element) => element.choose == true).isEmpty;
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: Stream.periodic(Duration(hours: 1)),
      builder: (context, snapshot) {
        int now = DateTime.now().add(Duration(hours: 2)).hour;
        return Stack(
          children: [
            Container(
              height: size.height * 0.45,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext ctx, int index) {
                  TimePesanModel data = this.data[index];
                  // bool active = data.canOrder;
                  bool active = data.canOrder &&
                      (this.isDateSame ? (data.start > now) : true);
                  return GestureDetector(
                      onTap: active ? () => choose(index) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              child: active
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.data[index].ket,
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        Icon(
                                          widget.data[index].choose
                                              ? Icons.check_box
                                              : Icons
                                                  .check_box_outline_blank_sharp,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      widget.data[index].ket,
                                      style: TextStyle(fontSize: 22),
                                    ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1.15,
                            )
                          ],
                        ),
                      ));
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onSurface: Colors.red,
                  primary: Colors.blue,
                ),
                onPressed: isEmp ? null : () => process(),
                child: Text(isEmp ? "Pilih dahulu" : "Next",
                    style: TextStyle(fontSize: 25)),
              ),
            )
          ],
        );
      },
    );
  }
}
