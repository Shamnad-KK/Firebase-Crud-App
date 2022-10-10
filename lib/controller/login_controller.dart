import 'package:firebase_crud/repository/login_repository.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  bool passObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  void setPasswordObscure() {
    passObscure = !passObscure;
    notifyListeners();
  }

  void clearFields() {
    emailController.clear();
    passController.clear();
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    setLoading(true);
    await LoginRepository()
        .loginWithEmail(context, emailController.text, passController.text);
    setLoading(false);
  }
}
