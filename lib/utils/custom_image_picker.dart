import 'dart:io';

import 'package:firebase_crud/utils/app_popups.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomImagePicker {
  static Future<File?> pickImage() async {
    File? imagePath;
    await Permission.photos.request();
    final permissionStatus = Permission.photos.status;
    if (await permissionStatus.isGranted) {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return null;
      } else {
        imagePath = File(image.path);
      }
    } else {
      AppPopUps().showToast("Permission not granted", Colors.red);
    }
    return imagePath;
  }
}
