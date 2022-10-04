import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/model/student_model.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StudentModifyRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<StudentModel?> addStudent(
    String name,
    String age,
    String domain,
    File? image,
    String mobile,
  ) async {
    try {
      StudentModel? studentModel;
      String uid = const Uuid().v4();
      String? photoUrl;
      const String path = "images";

      //Uploading image to firebase storage
      if (image != null) {
        await uploadStudentImage(image, uid, path);
      }
      //Getting the download url
      photoUrl = await getStudentProfilePic(uid);

      studentModel = StudentModel(
        name: name,
        age: age,
        domain: domain,
        profilePic: photoUrl!,
        mobile: mobile,
        uid: uid,
      );

      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("students")
          .doc(uid)
          .set(studentModel.toMap());
      log("student model is not null");
      return studentModel;
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    }
    return null;
  }

  //This is a method for uploading image to firebase storage
  Future<String?> uploadStudentImage(
      File? image, String uid, String path) async {
    try {
      //CreateRefernce to path
      Reference ref = storage.ref().child("$path/");
      //TaskSnapshot is used to put the data you want in storage
      //Make sure to get the image first before calling this method otherwise _image will be null.

      TaskSnapshot snapshot = await ref
          .child("students/")
          .child("profilepic/")
          .child(uid)
          .putFile(image!);

      if (snapshot.state == TaskState.running) {
        //
      } else if (snapshot.state == TaskState.canceled) {
        AppPopUps().showToast("Upload cancelled", Colors.red);
      }
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
    return null;
  }

//  Future<String?> uploadStudentImage(File? image) async {
//     try {
//       if (image != null) {
//         const String path = "images";
//         //CreateRefernce to path
//         Reference ref = storage.ref().child("$path/");
//         //StorageUpload task is used to put the data you want in storage
//         //Make sure to get the image first before calling this method otherwise _image will be null.

//         UploadTask uploadTask = ref
//             .child("students")
//             .child("profilepic/")
//             .child("${auth.currentUser!.email}")
//             .putFile(image);

//         if (uploadTask.snapshot.state == TaskState.running) {
//           uploadTask.snapshotEvents.listen((event) {
//             //
//           });
//         } else if (uploadTask.snapshot.state == TaskState.canceled) {
//           AppPopUps().showToast("Upload cancelled", Colors.red);
//         }
//       }
//     } on FirebaseException catch (e) {
//       AppPopUps().showToast(e.message!, Colors.red);
//     } catch (e) {
//       AppPopUps().showToast(e.toString(), Colors.red);
//     }
//     return null;
//   }
  Future<String?> getStudentProfilePic(String uid) async {
    String? downloadUrl;
    try {
      const String path = "images";
      downloadUrl = await storage
          .ref()
          .child("$path/")
          .child("students/")
          .child("profilepic/")
          .child(uid)
          .getDownloadURL();

      log(downloadUrl);
      return downloadUrl;
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

  Stream<List<StudentModel>> fetchAllStudents() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("students")
        .snapshots()
        .asyncMap((event) async {
      List<StudentModel> students = [];
      for (var element in event.docs) {
        final st = StudentModel.fromMap(element.data());
        students.add(st);
      }
      return students;
    });
  }

//Name validation
  String? nameValidation(String name) {
    if (name.isEmpty) {
      return "Name shouldn't be empty";
    } else if (name.startsWith(RegExp(r'[0-9]'))) {
      return "Name cannot start with numbers";
    } else {
      return null;
    }
  }

  //Mobile validation
  String? mobileValidation(String mobile) {
    if (mobile.isEmpty) {
      return "Number shouldn't be empty";
    } else if (mobile.length > 10) {
      return "Number is badly formated";
    } else {
      return null;
    }
  }

  //Age validation
  String? ageValidation(String age) {
    if (age.isEmpty) {
      return "Age shouldn't be empty";
    } else if (age.length > 400) {
      return "Number is badly formated";
    } else {
      return null;
    }
  }

  //Mobile validation
  String? domainValidation(String domain) {
    if (domain.isEmpty) {
      return "Domain shouldn't be empty";
    } else {
      return null;
    }
  }
}
