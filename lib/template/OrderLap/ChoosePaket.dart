import 'package:flutter/material.dart';

class ChoosePaket extends StatelessWidget {
  final double size;
  final String ket;
  final String title;
  final String harga;
  // final String category;
  ChoosePaket(
      {required this.size,
      // this.category = 'L',
      this.ket = '',
      this.harga = '',
      this.title = ''});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: 130,
      decoration: BoxDecoration(
          color: Colors.blueGrey[700], borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(harga,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                )),
          ),
          Text(ket,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[300],
              )),
        ],
      ),
    );
  }
}
