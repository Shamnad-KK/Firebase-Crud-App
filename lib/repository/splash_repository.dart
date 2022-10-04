import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:firebase_crud/view/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> chekAuthState(BuildContext context) async {
    if (auth.currentUser == null) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
    } else {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
      );
    }
  }
}
