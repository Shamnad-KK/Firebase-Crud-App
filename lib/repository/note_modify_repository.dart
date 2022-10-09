import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
}
