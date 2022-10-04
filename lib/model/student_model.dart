import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String name;
  final String age;
  final String domain;
  final String profilePic;
  final String mobile;
  final String uid;
  final DateTime date;

  StudentModel({
    required this.name,
    required this.age,
    required this.domain,
    required this.profilePic,
    required this.mobile,
    required this.uid,
    required this.date,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map["name"],
      age: map["age"],
      domain: map["domain"],
      profilePic: map["profilePic"],
      mobile: map["mobile"],
      uid: map["uid"],
      date: (map["date"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "age": age,
      "domain": domain,
      "profilePic": profilePic,
      "mobile": mobile,
      "uid": uid,
      "date": date,
    };
  }
}
