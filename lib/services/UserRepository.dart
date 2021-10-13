import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation/model/UserData.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Login,
  Register
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  UserData? userData;
  final firestore = FirebaseFirestore.instance;
  Status _status = Status.Uninitialized;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User? get user => _user;

  Future<void> signIn(String email, String password) async {
    DocumentSnapshot d;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      d = await firestore.collection('users').doc(user.user?.uid).get();
      bool admin = d.data().toString().contains('admin') ? d['admin'] : false;
      String nama = d.data().toString().contains('nama') ? d['nama'] : '';
      String hp = d.data().toString().contains('hp') ? d['hp'] : '';
      setDataUser({'nama': nama, 'hp': hp, 'admin': admin});
      userData = UserData(nama, hp, admin);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String mes;
      switch (e.code) {
        case 'invalid-email':
          mes = 'Akun tidak ditemukan';
          break;
        case 'wrong-password':
          mes = 'Kata sandi anda salah';
          break;
        default:
          mes = 'Terjadi masalah, silahkan dicoba lagi nanti';
      }
      _status = Status.Unauthenticated;
      notifyListeners();
      throw mes;
    } catch (e) {
      print('error');
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      throw 'Terjadi masalah, silahkan dicoba lagi nanti';
    }
  }

  Future signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _auth.signOut();
      _status = Status.Unauthenticated;
      await prefs.remove('user');
      userData = null;
      notifyListeners();
    } catch (e) {
      print(e);
    }

    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      userData = await getDataUser();
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<void> setDataUser(Map data, {bool delete = false}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(data));
    } catch (e) {}
  }

  Future<UserData?> getDataUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map data = jsonDecode(
          prefs.getString('user') ?? '{"nama":"","hp":"","admin":false}');
      bool admin = data.containsKey('admin') ? data['admin'] : false;
      return UserData(
        data['nama'],
        data['hp'],
        admin,
      );
    } catch (e) {}
    return null;
  }

  Future<bool> signUp(
      String email, String password, String hp, String name) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String name = email.split('@').first;
      await firestore
          .collection('users')
          .doc(res.user?.uid)
          .set({'hp': hp, 'nama': name});
      setDataUser({'nama': name, 'hp': hp, 'admin': false});
      userData = UserData(name, hp, false);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      String mes;
      switch (e.code) {
        case 'invalid-email':
          mes = 'Masukkan email yang benar';
          break;
        case 'email-already-in-use':
          mes = 'Akun sudah terdaftar, silahkan menggunakan menu Login';
          break;
        default:
          mes = 'Terjadi masalah, silahkan dicoba lagi nanti';
      }
      _status = Status.Unauthenticated;
      notifyListeners();
      throw mes;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw 'Maaf bermasalah';
    }
  }
}
