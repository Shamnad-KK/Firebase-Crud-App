import 'package:firebase_crud/model/user_model.dart';
import 'package:firebase_crud/repository/home_repository.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
  }

  UserModel? userData;

  Future<void> logout(BuildContext context) async {
    setLoading(true);
    _isLoading = true;
    await HomeRepository().logoutUser(context);
    setLoading(false);
    notifyListeners();
  }
}
