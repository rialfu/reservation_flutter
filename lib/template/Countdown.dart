import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {
  Countdown(
      {Key? key,
      required this.animation,
      this.fontSize = 40,
      this.color = Colors.black})
      : super(key: key, listenable: animation);
  final Animation<int> animation;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
