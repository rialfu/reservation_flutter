import 'package:provider/provider.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:reservation/services/UserRepository.dart';
// import 'package:reservation/model/Message.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController(text: 'rema@test.com');
  final passController = TextEditingController(text: '123456');
  bool req = true;
  Future<void> login(var user, BuildContext context) async {
    String email = emailController.text;
    String password = passController.text;
    if (email != '' && password != '' && req) {
      try {
        await user.signIn(email, password);
        Navigator.of(context).pop();
        // return;
      } catch (e) {
        final snackBar = SnackBar(
            content: Text(
          '$e',
          style: TextStyle(fontSize: 17),
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
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
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 60.0,
            ),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          "image/logoo.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        height: 400.0,
                        width: 350.0,
                        padding: EdgeInsets.only(
                          top: 55,
                          left: 28,
                          right: 28,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: const Color(0xFFFDFEF8),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'BalooTammudu2',
                                  color: Colors.black,
                                  fontSize: 33.0,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w700,
                                  height: 0.3,
                                ),
                              ),
                              SizedBox(height: 40.0),
                              Text(
                                'Username',
                                style: TextStyle(
                                  fontFamily: 'BalooTammudu2',
                                  fontSize: 14,
                                  color: const Color(0xffb7b7b7),
                                  fontWeight: FontWeight.w500,
                                  height: 0.8,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 38.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19.0),
                                  color: const Color(0xffe1e2dd),
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: 'BalooTammudu2',
                                    fontSize: 17,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 14.0),
                                    hintText: 'Enter your Username',
                                    hintStyle: TextStyle(
                                      fontFamily: 'BalooTammudu2',
                                      fontSize: 17,
                                      color: const Color(0xff4D4D4D),
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.0),
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontFamily: 'BalooTammudu2',
                                  fontSize: 14,
                                  color: const Color(0xffb7b7b7),
                                  fontWeight: FontWeight.w500,
                                  height: 0.8,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 38.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19.0),
                                  color: const Color(0xffe1e2dd),
                                ),
                                child: TextFormField(
                                  controller: passController,
                                  obscureText: true,
                                  style: TextStyle(
                                    fontFamily: 'BalooTammudu2',
                                    fontSize: 17,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 14.0,
                                      // bottom: 14,
                                    ),
                                    hintText: 'Enter your Password',
                                    hintStyle: TextStyle(
                                      fontFamily: 'BalooTammudu2',
                                      fontSize: 17,
                                      color: const Color(0xffc4D4D4D),
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.0),
                              SizedBox(
                                width: double.infinity,
                                height: 38.4,
                                child: ElevatedButton(
                                  onPressed: () => login(user, context),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    primary: const Color(0xff2196F3),
                                  ),
                                  child: Text(
                                    'LOGIN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 15,
                                      color: const Color(0xffffffff),
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        height: 55.0,
                        width: 250.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24.0),
                              bottomRight: Radius.circular(24.0)),
                          color: const Color(0xd1fefff5),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
