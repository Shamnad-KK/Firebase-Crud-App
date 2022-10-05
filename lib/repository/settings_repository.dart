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
      await firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) async {
        userModel = UserModel.fromMap(value.data()!);
        // await getUserProfilePic();
      });
      return userModel;
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

        UploadTask uploadTask = ref.child("profilepic/").putFile(image);

        if (uploadTask.snapshot.state == TaskState.running) {
          uploadTask.snapshotEvents.listen((event) {
            percentage = 100 *
                (event.bytesTransferred.toDouble() /
                    event.totalBytes.toDouble());

            AppPopUps().showToast("${percentage?.round()} %", Colors.green);
            //Here you can get the download URL when the task has been completed.
            log("THe percentage $percentage");
          });
        } else if (uploadTask.snapshot.state == TaskState.canceled) {
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
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
    if (downloadUrl != null) {
      return downloadUrl;
    }
    return null;
  }

  Future<void> signout(BuildContext context) async {
    final navContext = Navigator.of(context);
    await auth.signOut();
    await navContext.pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const LoginScreen()),
        (route) => false);
  }
}
