import 'dart:developer';
import 'dart:io';

import 'package:firebase_crud/model/student_model.dart';
import 'package:firebase_crud/repository/student_modify_repository.dart';
import 'package:firebase_crud/utils/custom_image_picker.dart';
import 'package:flutter/material.dart';

class StudentModifyController extends ChangeNotifier {
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

  Future<void> saveStudentData() async {
    isLoading = true;
    if (image == null) {
      log("image is  null");
    } else if (studentModel == null) {
      log("studentmodel is  null");
    }
    await studentRepository.addStudent(
      nameController.text,
      ageController.text,
      domainController.text,
      image,
      mobileContoller.text,
    );

    isLoading = false;
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
