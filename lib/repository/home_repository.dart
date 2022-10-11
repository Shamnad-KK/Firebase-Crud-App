import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:flutter/material.dart';

class HomeRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      if (e.code == "too-many-requests") {
        AppPopUps().showToast("Please try again after some time", Colors.red);
      } else {
        AppPopUps().showToast(e.message!, Colors.red);
      }
    } catch (e) {
      AppPopUps().showToast(e.toString(), Colors.red);
    }
    return null;
  }

  Future<void> deleteNote(String uid) async {
    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("notes")
          .doc(uid)
          .delete();
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
