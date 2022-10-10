import 'package:firebase_crud/repository/forgot_password_repository.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends ChangeNotifier {
  final forgotPasswordRepository = ForgotPasswordRepository();
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword(BuildContext context) async {
    final navContext = Navigator.of(context);
    isLoading = true;
    notifyListeners();
    await forgotPasswordRepository.resetPassword(emailController.text.trim());
    isLoading = false;
    notifyListeners();

    navContext.pop();
  }
}
