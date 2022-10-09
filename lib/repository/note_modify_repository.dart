import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/model/student_model.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NoteModifyRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<NoteModel?> addNote(NoteModel? modal, String uid) async {
    NoteModel? noteModel;
    try {
      noteModel = NoteModel(
        title: modal?.title,
        date: modal?.date,
        colorId: modal?.colorId,
        noteContent: modal?.noteContent,
        uid: uid,
      );
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("notes")
          .doc(uid)
          .set(noteModel.toMap());
      return noteModel;
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
    return null;
  }

  Future<List<NoteModel>?> fetchAllNotes() async {
    List<NoteModel> notesList = [];
    try {
      final noteCollection = await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("notes")
          .orderBy("creation_date")
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> notes =
          noteCollection.docs;

      for (var element in notes) {
        final NoteModel noteData = NoteModel.fromMap(element.data());
        notesList.insert(0, noteData);
      }
      return notesList;
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
    return null;
  }

  Future<void> updateNote(String uid, NoteModel noteModel) async {
    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("notes")
          .doc(uid)
          .update(noteModel.toMap());
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
  }

  Future<StudentModel?> addStudent(
    BuildContext context,
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

        //Getting the download url
        photoUrl = await getStudentProfilePic(uid);

        studentModel = StudentModel(
          name: name,
          age: age,
          domain: domain,
          profilePic: photoUrl!,
          mobile: mobile,
          date: DateTime.now(),
          uid: uid,
        );

        await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .collection("students")
            .doc(uid)
            .set(studentModel.toMap());
        log("student model is not null");
        AppPopUps().showToast("Added successfully", Colors.green);
        return studentModel;
      }
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
      Reference ref =
          storage.ref().child(auth.currentUser!.email!).child("$path/");
      //TaskSnapshot is used to put the data you want in storage
      //Make sure to get the image first before calling this method otherwise _image will be null.

      TaskSnapshot snapshot = await ref
          .child("students/")
          .child(uid)
          .child("profilepic/")
          .child("dp")
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
          .child(auth.currentUser!.email!)
          .child("$path/")
          .child("students/")
          .child(uid)
          .child("profilepic/")
          .child("dp")
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
    } else {
      return null;
    }
  }

  Future<List<StudentModel>> fetchAllStudents() async {
    List<StudentModel> studentList = [];
    try {
      final studentCollection = await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("students")
          .orderBy("date")
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documentList =
          studentCollection.docs;

      for (var element in documentList) {
        final StudentModel studentData = StudentModel.fromMap(element.data());
        studentList.insert(0, studentData);
        // studentList.add(studentData);
      }
      return studentList;
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      log(e.toString());
    }

    return studentList;
  }

  Future<void> updateStudentData(
    String name,
    String age,
    String domain,
    File? image,
    String mobile,
    String uid,
    BuildContext context,
  ) async {
    final navContext = Navigator.of(context);
    StudentModel? studentModel;
    const String path = "images";
    String? photoUrl;
    try {
      if (image != null) {
        await uploadStudentImage(image, uid, path);
      }
      photoUrl = await getStudentProfilePic(uid);
      studentModel = StudentModel(
        name: name,
        age: age,
        domain: domain,
        profilePic: photoUrl!,
        mobile: mobile,
        date: DateTime.now(),
        uid: uid,
      );
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("students")
          .doc(uid)
          .update(studentModel.toMap());
      await navContext.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const HomeScreen(),
          ),
          (route) => false);
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
  }

  Future<void> deleteStudent(String uid) async {
    const String path = "images";
    try {
      Reference ref =
          storage.ref().child(auth.currentUser!.email!).child("$path/");
      await ref
          .child("students/")
          .child(uid)
          .child("profilepic/")
          .child("dp")
          .delete();
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("students")
          .doc(uid)
          .delete();
    } on FirebaseException catch (e) {
      AppPopUps().showToast(e.message!, Colors.red);
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
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
