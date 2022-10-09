import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeController extends ChangeNotifier {
  String? deleteUid;
  HomeRepository homeRepository = HomeRepository();

  double opacity = 0;

  int? colorId;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<NoteModel>? noteList;

  Future<void> fetchAllNotes() async {
    noteList = await HomeRepository().fetchAllNotes();
    notifyListeners();
  }

  Future<void> deleteNote(String uid) async {
    setLoading(true);
    await homeRepository.deleteNote(uid);
    setLoading(false);
  }

  void removeFromList(NoteModel? note) {
    noteList?.remove(note);
    notifyListeners();
  }

  String formatDate(DateTime dateTime) {
    return DateFormat.yMd().add_jm().format(
          dateTime,
        );
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setDeleteOpacity(double newOpacity) {
    opacity = newOpacity;
    notifyListeners();
  }

  void setDeleteColor(int? newColorID) {
    colorId = newColorID;
    notifyListeners();
  }
}
