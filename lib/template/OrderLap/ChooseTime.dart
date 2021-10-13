import 'package:flutter/material.dart';
import '../../model/OrderLapangan/TimePesanModel.dart';
// import '../../model/OrderUser/TimePesanModel.dart';

class ChooseTime extends StatefulWidget {
  final List<TimePesanModel> data;
  final bool dateIsSame;
  final Function callback;
  final Function callback2;
  ChooseTime(
      {required this.data,
      required this.callback,
      required this.callback2,
      this.dateIsSame = true});
  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  List<TimePesanModel> data = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEmp = widget.data.where((element) => element.choose == true).isEmpty;
    Size size = MediaQuery.of(context).size;

    bool dateIsSame = widget.dateIsSame;
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
                    bool active = data.canOrder &&
                        (dateIsSame ? (data.start > now) : true);
                    return GestureDetector(
                        onTap: active ? () => widget.callback(index) : null,
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
                                          Text(widget.data[index].ket,
                                              style: TextStyle(fontSize: 22)),
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
                                    : Text(widget.data[index].ket,
                                        style: TextStyle(fontSize: 22)),
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
                      onSurface: Colors.red, primary: Colors.blue),
                  onPressed: isEmp ? null : () => widget.callback2(),
                  child: Text(isEmp ? "Pilih dahulu" : "Next",
                      style: TextStyle(fontSize: 25)),
                ),
              )
            ],
          );
        });
  }
}
