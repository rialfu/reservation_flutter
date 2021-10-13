import 'package:flutter/material.dart';

class HeaderLapWidget extends StatelessWidget {
  final String text;
  final bool choose;
  final Function callback;
  final int length;
  final int index;
  HeaderLapWidget({
    required this.text,
    required this.choose,
    required this.callback,
    required this.length,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = (size.width - (36 + 10 * 2 * (length - 1))) / length;
    EdgeInsets margin;
    if (index == 0)
      margin = EdgeInsets.only(right: 10);
    else if (index + 1 == length)
      margin = EdgeInsets.only(left: 10);
    else
      margin = EdgeInsets.symmetric(horizontal: 10);
    // double widthH = (size.width - (36 + 10 * 4)) / 3;

    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: () => callback(),
        child: Text(this.text),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0),
            ),
            fixedSize: Size(width, 40),
            textStyle: TextStyle(fontSize: 16, color: Colors.white),
            primary: choose ? Colors.grey[600] : Colors.green[400]),
      ),
    );
  }
}
