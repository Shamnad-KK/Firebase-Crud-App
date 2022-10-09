import 'dart:math';

import 'package:firebase_crud/constants/enums.dart';
import 'package:firebase_crud/controller/home_controller.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/repository/note_modify_repository.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NoteModifyController extends ChangeNotifier {
  NoteModifyRepository noteModifyRepository = NoteModifyRepository();

  HomeController homeController = HomeController();

  TextEditingController? titleController = TextEditingController();
  final TextEditingController? contentController = TextEditingController();

  int colorId = Random().nextInt(AppColors.cardColors.length);

  bool isLoading = false;

  String? date;
  void valueAssign(ScreenAction type, NoteModel? note) {
    if (type == ScreenAction.editScreen) {
      titleController?.text = note!.title!;
      contentController?.text = note!.noteContent!;
      date = homeController.formatDate(note!.date!);
    } else {
      titleController?.clear();
      contentController?.clear();
      date = homeController.formatDate(DateTime.now());
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
      noteContent: contentController?.text,
      uid: uid,
    );

    await noteModifyRepository.addNote(noteModel, uid);
    await HomeController().fetchAllNotes();
    isLoading = false;
    notifyListeners();
    await navContext.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
        (route) => false);
  }

  void updateNote(BuildContext context, String uid, int currentColorId) async {
    isLoading = true;
    final navContext = Navigator.of(context);

    final noteModel = NoteModel(
        title: titleController?.text,
        date: DateTime.now(),
        colorId: currentColorId,
        noteContent: contentController?.text,
        uid: uid);
    await noteModifyRepository.updateNote(uid, noteModel);
    await HomeController().fetchAllNotes();
    isLoading = false;
    notifyListeners();
    navContext.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const HomeScreen(),
        ),
        (route) => false);
  }
}
