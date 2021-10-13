import 'package:flutter/material.dart';
import 'package:reservation/extensions/MSP.dart';
import 'package:reservation/services/UserRepository.dart';
import 'package:provider/provider.dart';
import 'package:reservation/extensions/StringExtension.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool load = false;
  final emailController = TextEditingController(text: 'aldi@test.com');
  final passController = TextEditingController(text: '123456');
  final confirmController = TextEditingController(text: '123456');
  final phoneController = TextEditingController(text: '08220000000');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> process(BuildContext context) async {
    setState(() {
      this.load = true;
    });
    if (_formKey.currentState!.validate()) {
      final user = Provider.of<UserRepository>(context, listen: false);
      String email = emailController.text;
      String pass = passController.text;
      String phone = phoneController.text;
      try {
        await user.signUp(email, pass, phone, 'Aldi');
        Navigator.of(context).pop();
        return;
      } catch (e) {
        final snackBar = SnackBar(
            content: Text(
          '$e',
          style: TextStyle(fontSize: 17),
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() {
      this.load = false;
    });
    // if (load) return;
    // final user = Provider.of<UserRepository>(context, listen: false);
    // String email = emailController.text;
    // String pass = passController.text;
    // String phone = phoneController.text;
    // String confirm = confirmController.text;
    // try {
    //   setState(() {
    //     this.load = true;
    //   });
    //   if (email == '' || pass == '' || phone == '' || confirm == '') {
    //     throw 'Mohon form pastikan semua diisi';
    //   }
    //   if (confirm != pass) {
    //     throw 'Password and Confirmation is not same';
    //   }
    //   await user.signUp(email, pass, phone, '');
    // } catch (e) {
    //   var sb = SnackBar(content: new Text(e.toString()));
    //   ScaffoldMessenger.of(context).showSnackBar(sb);
    // }
    // setState(() {
    //   this.load = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: ,
      body: Container(
        height: size.height,
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
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "image/logoo.png",
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Container(
                  width: size.width * 0.85,
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daftar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Email"),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: emailController,
                        decoration: decoration(),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          String value = val ?? '';
                          if (value.isEmpty) return 'form harus diisi';
                          if (!value.isValidEmail()) return 'form harus email';
                          return null;
                        },
                        // validator: ,
                      ),
                      SizedBox(height: 8),
                      Text("No. Hp"),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: decoration(),
                        validator: (val) {
                          String value = val ?? '';
                          if (value.isEmpty) return 'form harus diisi';
                          if (value.length < 8 || value.length > 15)
                            return 'form harus no HP';
                          return null;
                        },
                        // validator: ,
                      ),
                      SizedBox(height: 8),
                      Text("Password"),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: passController,
                        obscureText: true,
                        decoration: decoration(),
                        validator: (val) {
                          String value = val ?? '';
                          if (value.isEmpty) return 'form harus diisi';
                          if (value.length < 6)
                            return 'form harus minimal 6 karater';
                          return null;
                        },
                        // validator: ,
                      ),
                      SizedBox(height: 8),
                      Text("Confirmation Password"),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: confirmController,
                        obscureText: true,
                        decoration: decoration(),
                        validator: (val) {
                          String value = val ?? '';
                          if (value.isEmpty) return 'form harus diisi';
                          if (value != passController.text)
                            return 'confirm harus sama dengan password';
                          return null;
                        },
                        // validator: ,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => load ? null : process(context),
                          style: ButtonStyle(
                            shape: MSP.rectangle(10),
                            // fixedSize: MSP.size(size.width * 0.5, 40),
                            minimumSize: MSP.size(size.width * 0.5, 40),
                            padding: MSP.jarak(0, 10, 0, 10),
                          ),
                          child: load
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Register",
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration decoration() {
    return InputDecoration(
      // labelText: 'Email',
      fillColor: Colors.grey[100],
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        // borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      // helperStyle: TextStyle(
      //     // decoration: TextDecoration
      //     ),
    );
  }
  // Widget form(){
  //   return
  // }
}
