import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _sub;
  User? user;

  void init() {
    _sub = _auth.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  bool get isLoggedIn => user != null;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String name, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(cred.user!.uid)
        .set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> signOut() => _auth.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
