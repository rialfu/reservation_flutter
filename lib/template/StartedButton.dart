import 'package:flutter/material.dart';

// typedef void StringCallback(String val);

class StartedButton extends StatelessWidget {
  StartedButton(
      {required this.callback, required this.judul, required this.color});
  final Function callback;
  final String color;
  final String judul;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: color == 'white' ? Colors.grey[300] : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            // side: BorderSide(color: Colors.black) // <-- Radius
          )),
      onPressed: () => callback(judul),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          judul,
          style: TextStyle(
            fontSize: 30,
            color: color == 'white' ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }
}
