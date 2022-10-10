import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/model/user_model.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:flutter/material.dart';

class RegisterRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // This is a method for creating an user with email and password
  Future<void> signUpWithEmail(
    BuildContext context,
    String email,
    String username,
    String password,
  ) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final userModel = UserModel(
          userName: username,
          email: email,
          uid: FirebaseAuth.instance.currentUser!.uid,
        );
        await saveUserData(userModel);

        await sendEmailVerification();
      });
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      switch (e.code) {
        case "invalid-email":
          AppPopUps().showToast("E-mail is not valid", Colors.red);
          break;

        case "weak-password":
          AppPopUps().showToast(
              "Password should have atleast 6 characters", Colors.red);
          break;
        case "email-already-in-use":
          AppPopUps().showToast(
              "There is already an account in this email", Colors.red);
          break;
        default:
          AppPopUps().showToast(e.message!, Colors.red);
          break;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // This is a method for sending email verification from firebase to the given email
  Future<void> sendEmailVerification() async {
    try {
      await auth.currentUser!
          .sendEmailVerification()
          .then((value) =>
              AppPopUps().showToast("Email verification send", Colors.green))
          .catchError((c) => AppPopUps().showToast(c.toString(), Colors.green));
    } on FirebaseAuthException catch (e) {
      AppPopUps().showToast(e.message!, Colors.green);
    }
  }

  //This is a method for saving user credentials to firebase firestore
  Future<void> saveUserData(UserModel userModel) async {
    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set(userModel.toMap());
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    }
  }

  //Username validation
  String? userNameValidation(String userName) {
    if (userName.isEmpty) {
      return "Username shouldn't be empty";
    } else if (userName.startsWith(RegExp(r'[0-9]'))) {
      return "Username cannot start with numbers";
    } else {
      return null;
    }
  }

  //E-mail validation
  String? emailValidation(String email) {
    if (email.isEmpty) {
      return "E-mail shouldn't be empty";
    } else if (!email.contains("@")) {
      return "E-mail is badly formated";
    } else {
      return null;
    }
  }

  //Password validation
  String? passValidation(String pass) {
    if (pass.isEmpty) {
      return "Password shouldn't be empty";
    } else if (pass.length < 6) {
      return "Password should have atleast 6 characters";
    } else {
      return null;
    }
  }

  //Confirm Password validation
  String? retypePassValidation(String pass, String rePass) {
    if (rePass.isEmpty) {
      return "Password shouldn't be empty";
    } else if (pass != rePass) {
      return "Passwords doesn't match";
    } else if (rePass.length < 6) {
      return "Password should have atleast 6 characters";
    } else {
      return null;
    }
  }
}
