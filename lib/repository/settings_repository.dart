import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/model/user_model.dart';
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
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
    return userModel;
  }

//This is a method for uploading image to firebase storage
  Future<void> uploadImage(File? image, double? percentage) async {
    try {
      if (image != null) {
        const String path = "images";
        //CreateRefernce to path
        Reference ref =
            storage.ref().child(auth.currentUser!.email!).child("$path/");

        //StorageUpload task is used to put the data you want in storage
        //Make sure to get the image first before calling this method otherwise _image will be null.

        TaskSnapshot snapshot = await ref.child("profilepic/").putFile(image);

        if (snapshot.state == TaskState.running) {
          percentage = 100 *
              snapshot.bytesTransferred.toDouble() /
              snapshot.totalBytes.toDouble();

          AppPopUps().showToast("${percentage.round()} %", Colors.green);
          //Here you can get the download URL when the task has been completed.
          log("THe percentage $percentage");
        } else if (snapshot.state == TaskState.canceled) {
          AppPopUps().showToast("Upload cancelled", Colors.red);
        }
      }
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
  }

  Future<String?> getUserProfilePic() async {
    String? downloadUrl;
    try {
      const String path = "images";

      downloadUrl = await storage
          .ref()
          .child(auth.currentUser!.email!)
          .child("$path/")
          .child("profilepic/")
          .getDownloadURL();
      log(downloadUrl);
      return downloadUrl;
    } on FirebaseException catch (e) {
      log(e.toString());
      //  AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      log(e.toString());
      //  AppPopUps().showToast(e.toString(), Colors.red);
    }

    return null;
  }

  Future<void> updateUserData(String email, String password) async {
    try {
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
          {"email": email, "uid": auth.currentUser!.uid},
        );
      });
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

  Future<void> signout(BuildContext context) async {
    final navContext = Navigator.of(context);
    await auth.signOut();
    await navContext.pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const LoginScreen()),
        (route) => false);
  }
}
