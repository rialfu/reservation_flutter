import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation/model/AuthUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String? hp;
  AuthUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return AuthUser(uid: user.uid, email: user.email);
  }

  Stream<AuthUser?>? get user {
    auth.authStateChanges().map(_userFromFirebase);
  }

  Future<AuthUser?> signIn(String email, String password) async {
    UserCredential res =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(res.user);
  }

  Future<AuthUser?> signUp(
      String email, String password, String hp, String name) async {
    UserCredential res = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // User user = res.user;
    await firestore
        .collection('users')
        .doc(res.user?.uid)
        .set({hp: hp, name: name});
    return _userFromFirebase(res.user);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
