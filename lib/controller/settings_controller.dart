import 'dart:io';

import 'package:firebase_crud/model/user_model.dart';
import 'package:firebase_crud/repository/settings_repository.dart';
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

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> fetchUserData() async {
    isLoading = true;
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
          final navContext = Navigator.of(context);
          return PassWordTextFieldWidget(
            onTap: () async {
              buttonLoading = true;
              notifyListeners();
              await SettingsRepository().updateUserData(emailController.text,
                  passwordController.text, usernameController.text, context);
              buttonLoading = false;
              notifyListeners();
              await navContext.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()),
                  (route) => false);
            },
          );
        });
    passwordController.clear();
  }

  void signOut(BuildContext context) async {
    isLoading = true;
    AppPopUps().showAlertBox(context, "log out", ontap: () async {
      await SettingsRepository().signout(context);
      AppPopUps().showToast("logged out successfully", Colors.green);
    });
    isLoading = false;
    notifyListeners();
  }
}
