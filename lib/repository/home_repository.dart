import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/login/login_screen.dart';
import 'package:flutter/material.dart';

class HomeRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //This is a method for logging out the user
  Future<void> logoutUser(BuildContext context) async {
    try {
      await auth.signOut().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const LoginScreen()),
            (route) => false);
      });
    } on FirebaseAuthException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    }
  }
}
