import 'package:firebase_crud/repository/register_repository.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  RegisterRepository registerRepository = RegisterRepository();
  bool passObscure = true;
  bool rePassObscure = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();
  TextEditingController retypePassController = TextEditingController();

  void setPasswordObscure() {
    passObscure = !passObscure;
    notifyListeners();
  }

  void setRetypePasswordObscure() {
    rePassObscure = !rePassObscure;
    notifyListeners();
  }

  Future<void> signUpUser(BuildContext context) async {
    await registerRepository.signUpWithEmail(
      context,
      emailController.text,
      usernameController.text,
      passController.text,
    );

    usernameController.clear();
    emailController.clear();
    passController.clear();
    retypePassController.clear();
    AppPopUps().showToast("Registered successfully", Colors.green);
    notifyListeners();
  }

  String? userNameValidation() {
    return registerRepository.userNameValidation(usernameController.text);
  }

  String? emailValidation() {
    return registerRepository.emailValidation(emailController.text);
  }

  String? passwordValidation() {
    return registerRepository.passValidation(passController.text);
  }

  String? retypePasswordValidation() {
    return registerRepository.retypePassValidation(
        passController.text, retypePassController.text);
  }
}
