import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;
  String? get uid => _user?.uid;
  LoginProvider() {
    _user = _auth.currentUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    //taskprovider?.setUserId(null);
    notifyListeners();
  }

  Future<UserCredential> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _user = userCredential.user;

    notifyListeners();

    return userCredential;
  }

  Future<void> signUp(String email, String password) async {
    UserCredential uc = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('user').doc(uc.user!.uid).set({
      'email': email,
      'password': password,
    });

    _user = _auth.currentUser;

    notifyListeners();
  }
}
