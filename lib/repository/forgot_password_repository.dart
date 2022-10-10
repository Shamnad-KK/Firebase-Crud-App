import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email).then((value) =>
          AppPopUps().showToast(
              "A password reset link has been sent to your email",
              Colors.green,
              Toast.LENGTH_LONG));
    } on FirebaseAuthException catch (e) {
      log(e.code);
      switch (e.code) {
        case "invalid-email":
          AppPopUps().showToast("E-mail is not valid", Colors.red);
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
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
  }
}
