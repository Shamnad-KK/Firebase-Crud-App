import 'package:firebase_crud/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AppPopUps {
  void showToast(String text, Color color,
      [Toast? toastLength = Toast.LENGTH_SHORT]) async {
    await Fluttertoast.cancel();
    await Fluttertoast.showToast(
        msg: text, backgroundColor: color, toastLength: toastLength);
  }

  void showAlertBox(
    BuildContext context,
    String content, {
    required VoidCallback ontap,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are you sure ?"),
        content: Text("Do you want to $content"),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<HomeController>(context, listen: false)
                  .setDeleteOpacity(
                0,
              );
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ontap();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
