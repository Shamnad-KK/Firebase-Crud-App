import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/repository/register_repository.dart';
import 'package:firebase_crud/utils/animated_page_transitions.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:flutter/material.dart';

class LoginRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // This is a method for loggin in an user with email and password
  Future<void> loginWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await AnimatedPageTransitions.scaleTransitionAndRemoveUntil(
            context, const HomeScreen());
      });
      if (!auth.currentUser!.emailVerified) {
        await RegisterRepository().sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      log(e.code);
      switch (e.code) {
        case "invalid-email":
          AppPopUps().showToast("E-mail is not valid", Colors.red);
          break;
        case "network-request-failed":
          AppPopUps().showToast("Network error", Colors.red);
          break;
        case "user-not-found":
          AppPopUps()
              .showToast("There is no user in this email address", Colors.red);
          break;
        case "wrong-password":
          AppPopUps().showToast("Password is incorrect", Colors.red);
          break;
        case "unknown":
          AppPopUps().showToast("Fields shouldn't be empty", Colors.red);
          break;
        case "weak-password":
          AppPopUps().showToast(
              "Password should have atleast 6 characters", Colors.red);
          break;

        default:
          AppPopUps().showToast(e.message!, Colors.red);
          break;
      }
    } on FirebaseException catch (e) {
      if (e.code == "too-many-requests") {
        AppPopUps().showToast("Please try again after some time", Colors.red);
      } else {
        AppPopUps().showToast(e.message!, Colors.red);
      }
    }
  }
}
