// ignore_for_file: use_build_context_synchronously

import 'package:firebase_crud/model/user_model.dart';
import 'package:firebase_crud/repository/settings_repository.dart';
import 'package:firebase_crud/utils/animated_page_transitions.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/home/home_screen.dart';
import 'package:firebase_crud/view/settings/widgets/password_textfield_widget.dart';
import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  bool isLoading = false;

  bool buttonLoading = false;

  UserModel? userModel;

  String? userName;
  String? email;

  final formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();
    userModel = await SettingsRepository().fetchUserData();
    usernameController.text = userModel?.userName ?? "";
    emailController.text = userModel?.email ?? "";
    isLoading = false;
    notifyListeners();
  }

  void updateUserData(BuildContext context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return PassWordTextFieldWidget(
            onTap: () async {
              buttonLoading = true;
              notifyListeners();
              await SettingsRepository().updateUserData(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  usernameController.text.trim(),
                  context);
              buttonLoading = false;
              notifyListeners();
              await AnimatedPageTransitions.scaleTransitionAndRemoveUntil(
                  context, const HomeScreen());
            },
          );
        });
    passwordController.clear();
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  void signOut(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    AppPopUps().showAlertBox(context, "log out", ontap: () async {
      await SettingsRepository().signout(context);
      AppPopUps().showToast("logged out successfully", Colors.green);
    });
    isLoading = false;
    notifyListeners();
  }
}
