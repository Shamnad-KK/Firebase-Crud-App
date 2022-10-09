import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:firebase_crud/constants/enums.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/model/student_model.dart';
import 'package:firebase_crud/repository/note_modify_repository.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/utils/custom_image_picker.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NoteModifyController extends ChangeNotifier {
  NoteModifyController() {
    fetchAllStudents();
  }
  NoteModifyRepository studentRepository = NoteModifyRepository();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileContoller = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController domainController = TextEditingController();

//
  TextEditingController? titleController = TextEditingController();
  final TextEditingController? mainController = TextEditingController();

  int colorId = Random().nextInt(AppColors.cardColors.length);

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  File? image;

  bool imageValidation = false;

  List<StudentModel>? studentList;

  List<NoteModel>? noteList;

  String formatDate(DateTime dateTime) {
    return DateFormat.yMd().add_jm().format(
          dateTime,
        );
  }

  String? date;
  void valueAssign(ScreenAction type, NoteModel? note) {
    if (type == ScreenAction.editScreen) {
      titleController?.text = note!.title!;
      mainController?.text = note!.noteContent!;
      date = formatDate(note!.date!);
    } else {
      titleController?.clear();
      mainController?.clear();
      date = formatDate(DateTime.now());
    }
  }

  void addNote(BuildContext context) async {
    final navContext = Navigator.of(context);
    isLoading = true;
    String uid = const Uuid().v4();

    NoteModel? noteModel = NoteModel(
      title: titleController?.text,
      date: DateTime.now(),
      colorId: colorId,
      noteContent: mainController?.text,
      uid: uid,
    );

    await studentRepository.addNote(noteModel, uid);
    await fetchAllNotes();
    isLoading = false;
    notifyListeners();
    await navContext.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
        (route) => false);
  }

  Future<void> fetchAllNotes() async {
    noteList = await studentRepository.fetchAllNotes();
    notifyListeners();
  }

  void updateNote(BuildContext context, String uid, int currentColorId) async {
    isLoading = true;
    final navContext = Navigator.of(context);

    final noteModel = NoteModel(
        title: titleController?.text,
        date: DateTime.now(),
        colorId: currentColorId,
        noteContent: mainController?.text,
        uid: uid);
    await studentRepository.updateNote(uid, noteModel);
    await fetchAllNotes();
    isLoading = false;
    notifyListeners();
    navContext.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
        (route) => false);
  }

  void pickImage() async {
    image = await CustomImagePicker.pickImage();

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
    final navContext = Navigator.of(context);
    isLoading = true;

    await studentRepository.addStudent(
      context,
      nameController.text,
      ageController.text,
      domainController.text,
      image,
      mobileContoller.text,
    );
    isLoading = false;
    clearData();
    notifyListeners();
    navContext.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
        (route) => false);
  }

  Future<void> updateStudentData(String uid, BuildContext context) async {
    isLoading = true;
    AppPopUps().showToast("updated successfully", Colors.green);
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

  Future<void> deleteStudent(String uid, BuildContext context) async {
    AppPopUps().showAlertBox(context, "delete", ontap: () async {
      await studentRepository.deleteStudent(uid).then((value) {
        AppPopUps().showToast("deleted successfully", Colors.green);
      });
      await fetchAllStudents();
    });

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
