import 'package:firebase_crud/controller/settings_controller.dart';
import 'package:firebase_crud/view/home/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PassWordTextFieldWidget extends StatelessWidget {
  const PassWordTextFieldWidget({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final settingsController =
        Provider.of<SettingsController>(context, listen: false);
    return AlertDialog(
      title: const Text('Please confirm your password'),
      content: CustomTextField(
        hintText: "Password",
        controller: settingsController.passwordController,
        keyboardType: TextInputType.text,
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onTap();
          },
          icon: const Icon(Icons.done),
          label: const Text("Confirm"),
        )
      ],
    );
    // return CustomTextField(
    //   hintText: "Password",
    //   controller: settingsController.passwordController,
    // );
  }
}
