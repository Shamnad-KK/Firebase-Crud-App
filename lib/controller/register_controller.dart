import 'package:firebase_crud/repository/register_repository.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  RegisterRepository registerRepository = RegisterRepository();
  bool passObscure = true;
  bool rePassObscure = true;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();
  TextEditingController retypePassController = TextEditingController();

  Future<void> signUpUser(BuildContext context) async {
    setLoading(true);
    final navContext = Navigator.of(context);
    await registerRepository.signUpWithEmail(
      context,
      emailController.text,
      usernameController.text,
      passController.text,
    );
    setLoading(false);

    await navContext.pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        (route) => false);
    usernameController.clear();
    emailController.clear();
    passController.clear();
    retypePassController.clear();
    AppPopUps().showToast("Registered successfully", Colors.green);
    notifyListeners();
  }

  void setLoading(bool newValue) {
    isLoading = newValue;
    notifyListeners();
  }

  void setPasswordObscure() {
    passObscure = !passObscure;
    notifyListeners();
  }

  void setRetypePasswordObscure() {
    rePassObscure = !rePassObscure;
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
