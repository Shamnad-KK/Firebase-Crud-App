import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppPopUps {
  void showToast(String text, Color color) async {
    await Fluttertoast.cancel();
    await Fluttertoast.showToast(msg: text, backgroundColor: color);
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
