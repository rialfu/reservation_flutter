import 'package:flutter/material.dart';

class MSP {
  static MaterialStateProperty<EdgeInsets> jarak(
      double left, double top, double rigth, double bottom) {
    return MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.fromLTRB(left, top, rigth, bottom),
    );
  }

  static MaterialStateProperty<Color> color(var property) {
    return MaterialStateProperty.all<Color>(property);
  }

  static MaterialStateProperty<Size> size(double width, double height) {
    return MaterialStateProperty.all<Size>(Size(width, height));
  }

  static MaterialStateProperty<OutlinedBorder> rectangle(
    double radius, {
    String jb = 'circular',
    double left = 0,
    right = 0,
    tl = 0,
    tr = 0,
    bl = 0,
    br = 0,
    widthBS = 0,
    bool border = false,
    var color = Colors.black,
  }) {
    BorderSide borderSide = BorderSide.none;
    if (border) borderSide = BorderSide(width: widthBS, color: color);
    BorderRadius borderRadius = BorderRadius.zero;
    if (jb == 'circular') {
      borderRadius = BorderRadius.circular(radius);
    } else if (jb == 'horizontal') {
      borderRadius = BorderRadius.horizontal(
        left: Radius.circular(left),
        right: Radius.circular(right),
      );
    } else if (jb == 'only') {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
        bottomLeft: Radius.circular(bl),
        bottomRight: Radius.circular(br),
      );
    }
    return MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: borderSide,
      ),
    );
  }
  // BorderRadius
}
