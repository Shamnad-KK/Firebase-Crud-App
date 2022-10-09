import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String? title;
  final DateTime? date;
  final int? colorId;
  final String? noteContent;
  final String uid;

  NoteModel({
    required this.title,
    required this.date,
    required this.colorId,
    required this.noteContent,
    required this.uid,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      title: map["note_title"],
      date: (map["creation_date"] as Timestamp).toDate(),
      colorId: map["color_id"] ?? 0,
      noteContent: map["note_content"],
      uid: map["uid"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "note_title": title,
      "creation_date": date,
      "color_id": colorId,
      "note_content": noteContent,
      "uid": uid,
    };
  }
}
