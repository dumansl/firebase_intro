import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  User? loggedInUser = FirebaseAuth.instance.currentUser;

  // Kaydolma işlemi
  Future<String?> createUserWithEmailAndPassword(
      String email, String password, String name, String lastName) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("users").doc(user!.uid).set(
          {
            'firstName': name,
            'lastName': lastName,
            'email': email,
            "avatarUrl": "",
            'registerDate': DateTime.now()
          },
        );
      }

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
      user = userCredential.user;
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

  //Avatar ekleme
  Future<void> addedAvatarUrl({
    required String avatarUrl,
  }) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db
          .collection("users")
          .doc(loggedInUser!.uid)
          .set({"avatarUrl": avatarUrl}, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Avatar URL ekleme hatası: $e");
    }
  }
}
