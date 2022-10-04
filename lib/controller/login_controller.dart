import 'package:firebase_crud/repository/login_repository.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool passObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  void setPasswordObscure() {
    passObscure = !passObscure;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    await LoginRepository()
        .loginWithEmail(context, emailController.text, passController.text);
  }
}
