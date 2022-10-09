import 'dart:io';

import 'package:firebase_crud/model/user_model.dart';
import 'package:firebase_crud/repository/settings_repository.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/utils/custom_image_picker.dart';
import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  SettingsController() {
    getUserProfilePic();
  }
  File? image;

  bool isLoading = false;

  UserModel? userModel;

  double percentage = 0.0;

  String? downloadUrl;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void pickImage() async {
    image = await CustomImagePicker.pickImage();
    notifyListeners();
  }

  Future<void> uploadImage() async {
    isLoading = true;
    await SettingsRepository().uploadImage(image, percentage);
    isLoading = false;
    notifyListeners();
  }

  void getUserProfilePic() async {
    isLoading = true;
    downloadUrl = await SettingsRepository().getUserProfilePic();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    isLoading = true;
    userModel = await SettingsRepository().fetchUserData();
    usernameController.text = userModel?.userName ?? "";
    emailController.text = userModel?.email ?? "";
    isLoading = false;
    notifyListeners();
  }

  // Future<void>updateUserData()async{
  //   await SettingsRepository().updateUserData(emailController.text, p)
  // }

  void signOut(BuildContext context) async {
    isLoading = true;
    AppPopUps().showAlertBox(context, "log out", ontap: () async {
      await SettingsRepository().signout(context);
      AppPopUps().showToast("logged out successfully", Colors.green);
      image = null;
    });
    isLoading = false;
    notifyListeners();
  }
}
