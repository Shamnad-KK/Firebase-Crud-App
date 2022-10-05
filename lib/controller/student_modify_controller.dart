import 'dart:developer';
import 'dart:io';

import 'package:firebase_crud/model/student_model.dart';
import 'package:firebase_crud/repository/student_modify_repository.dart';
import 'package:firebase_crud/utils/custom_image_picker.dart';
import 'package:flutter/material.dart';

class StudentModifyController extends ChangeNotifier {
  StudentModifyController() {
    fetchAllStudents();
  }
  StudentModifyRepository studentRepository = StudentModifyRepository();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileContoller = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController domainController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  File? image;

  bool imageValidation = false;

  StudentModel? studentModel;

  List<StudentModel>? studentList;

  void pickImage() async {
    image = await CustomImagePicker.pickImage();
    log("image picked");
    notifyListeners();
  }

  void setImageValidation() {
    if (image == null) {
      imageValidation = true;
    } else {
      imageValidation = false;
    }
    notifyListeners();
  }

  void clearData() {
    nameController.clear();
    mobileContoller.clear();
    ageController.clear();
    domainController.clear();
    image = null;
    notifyListeners();
  }

  Future<void> saveStudentData(BuildContext context) async {
    isLoading = true;
    if (image == null) {
      log("image is  null");
    } else if (studentModel == null) {
      log("studentmodel is  null");
    }
    await studentRepository.addStudent(
      context,
      nameController.text,
      ageController.text,
      domainController.text,
      image,
      mobileContoller.text,
    );
    clearData();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateStudentData(String uid, BuildContext context) async {
    isLoading = true;
    await studentRepository.updateStudentData(
        nameController.text,
        ageController.text,
        domainController.text,
        image,
        mobileContoller.text,
        uid,
        context);
    clearData();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllStudents() async {
    isLoading = true;
    studentList = await studentRepository.fetchAllStudents();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteStudent(String uid) async {
    await studentRepository.deleteStudent(uid);
    notifyListeners();
  }

  String? nameValidation() {
    return studentRepository.nameValidation(nameController.text);
  }

  String? mobileValidation() {
    return studentRepository.mobileValidation(mobileContoller.text);
  }

  String? ageValidation() {
    return studentRepository.ageValidation(ageController.text);
  }

  String? domainValidation() {
    return studentRepository.mobileValidation(domainController.text);
  }
}
