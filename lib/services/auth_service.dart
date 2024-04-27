import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kaydolma işlemi
  Future<String?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user?.uid;
    } catch (e) {
      debugPrint("Kaydolma hatası: $e");
      return null;
    }
  }

  // Giriş yapma işlemi
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user?.uid;
    } catch (e) {
      debugPrint("Giriş hatası: $e");
      return null;
    }
  }

  // Çıkış yapma işlemi
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Çıkış hatası: $e");
    }
  }
}
