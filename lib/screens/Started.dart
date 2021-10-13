import 'package:flutter/material.dart';
import 'package:reservation/template/StartedButton.dart';
import 'package:reservation/screens/Login.dart';
import 'package:reservation/screens/RegisterScreen.dart';

class Started extends StatefulWidget {
  @override
  _StartedState createState() => _StartedState();
}

class _StartedState extends State<Started> {
  void push(BuildContext context, String val) {
    if (val == 'Login') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else if (val == 'Register') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: ,
        body: Container(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1C547D),
              Color(0xFF146596),
              Color(0xFF0A78B3),
              Color(0xFF008ACD),
            ],
            stops: [0.1, 0.3, 0.6, 0.9],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Selamat Datang",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text("Golden Stick Sport Center",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 40),
                      child: StartedButton(
                          callback: (val) => push(context, val),
                          judul: 'Login',
                          color: ''),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      child: StartedButton(
                          callback: (val) => push(context, val),
                          judul: 'Register',
                          color: 'white'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
// class Started extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//   }
// }
