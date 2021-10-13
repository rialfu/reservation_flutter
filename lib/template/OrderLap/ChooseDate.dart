import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef void IntCallback(int val);

class ChooseDate extends StatelessWidget {
  final List<DateTime> dateList;
  final int index;
  final IntCallback callback;
  ChooseDate(this.dateList, this.index, this.callback);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double jarak = 9;
    double width = (size.width - (36 + 9 * 6)) / 4;
    return Container(
      height: 90,
      margin: EdgeInsets.only(top: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        itemBuilder: (ctx, index) {
          EdgeInsets margin;
          if (index == 0) {
            margin = EdgeInsets.only(right: jarak);
          } else if (index + 1 == dateList.length) {
            margin = EdgeInsets.only(left: jarak);
          } else {
            margin = EdgeInsets.symmetric(horizontal: jarak);
          }

          DateTime date = dateList[index];
          var bg = this.index == index ? Colors.blue[400] : Colors.white;
          var tc = this.index == index ? Colors.white : Colors.black87;
          String day = index == 0 ? 'Today' : DateFormat('E').format(date);
          return GestureDetector(
            onTap: () => callback(index),
            child: Container(
              width: width,
              padding: EdgeInsets.all(8),
              margin: margin,
              decoration: BoxDecoration(
                  color: bg, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Text(
                    day,
                    style: TextStyle(fontSize: 20, color: tc),
                  ),
                  Text(DateFormat('dd').format(date),
                      style: TextStyle(fontSize: 18, color: tc)),
                  Text(DateFormat('MMMM').format(date).substring(0, 3),
                      style: TextStyle(fontSize: 18, color: tc))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
