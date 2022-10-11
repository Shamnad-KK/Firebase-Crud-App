// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/model/user_model.dart';
import 'package:firebase_crud/utils/animated_page_transitions.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/login/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SettingsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserModel?> fetchUserData() async {
    UserModel? userModel;
    try {
      final data = await firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userModel = UserModel.fromMap(data.data()!);
      return userModel;
    } on FirebaseException catch (e) {
      if (e.code == "too-many-requests") {
        AppPopUps().showToast("Please try again after some time", Colors.red);
      } else {
        AppPopUps().showToast(e.message!, Colors.red);
      }
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
    return userModel;
  }

  Future<void> updateUserData(String email, String password, String userName,
      BuildContext context) async {
    try {
      if (email != "") {
        // if (!auth.currentUser!.emailVerified) {
        //   AppPopUps().showToast(
        //       "Please verify your account before changing the data",
        //       Colors.red,
        //       Toast.LENGTH_LONG);
        //   await RegisterRepository().sendEmailVerification();
        // } else {
        final credential = EmailAuthProvider.credential(
            email: auth.currentUser!.email!, password: password);
        await auth.currentUser!
            .reauthenticateWithCredential(credential)
            .then((value) async {
          await auth.currentUser!.updateEmail(email);
          await firestore
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(
            {
              "userName": userName,
              "email": email,
              "uid": auth.currentUser!.uid,
            },
          );
          AppPopUps().showToast("Updated successfully", Colors.green);
        });
        // }
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
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
  }

  Future<void> signout(BuildContext context) async {
    try {
      await auth.signOut();
      AppPopUps().showToast("Signed out", Colors.green);
      await AnimatedPageTransitions.scaleTransitionAndRemoveUntil(
          context, const LoginScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        AppPopUps().showToast(e.toString(), Colors.red);
      }
    } on FirebaseException catch (e) {
      if (e.code == "too-many-requests") {
        AppPopUps().showToast("Please try again after some time", Colors.red);
      } else {
        AppPopUps().showToast(e.message!, Colors.red);
      }
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
  }
}
