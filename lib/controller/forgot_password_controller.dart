import 'package:firebase_crud/repository/forgot_password_repository.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordController extends ChangeNotifier {
  final forgotPasswordRepository = ForgotPasswordRepository();
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword(BuildContext context) async {
    final navContext = Navigator.of(context);
    isLoading = true;
    notifyListeners();
    await forgotPasswordRepository.resetPassword(emailController.text);
    isLoading = false;
    notifyListeners();
    AppPopUps().showToast("A password reset link has been sent to your email",
        Colors.green, Toast.LENGTH_LONG);
    await navContext.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
        (route) => false);
  }
}
