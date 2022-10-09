import 'dart:developer';
import 'dart:io';

import 'package:firebase_crud/controller/settings_controller.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/view/home/widgets/custom_textfield.dart';
import 'package:firebase_crud/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController =
        Provider.of<SettingsController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      log(settingsController.isLoading.toString());
      await settingsController.fetchUserData();
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: ApptextStyle.bodyHeadline,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                settingsController.signOut(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPading.mainPading,
            child: Consumer<SettingsController>(
                builder: (BuildContext context, value, Widget? child) {
              return value.isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSpacing.kHeight40,
                        Stack(
                          children: [
                            value.image == null
                                ? value.downloadUrl != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          value.downloadUrl!,
                                        ))
                                    : const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png",
                                        ))
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        FileImage(File(value.image!.path)),
                                  ),
                            Positioned(
                              bottom: -10,
                              right: -10,
                              child: IconButton(
                                onPressed: () {
                                  settingsController.pickImage();
                                },
                                icon: const Icon(Icons.camera_alt),
                              ),
                            )
                          ],
                        ),
                        AppSpacing.kHeight10,
                        AppSpacing.kHeight40,
                        CustomTextField(
                          controller: settingsController.usernameController,
                          hintText: 'Username',
                        ),
                        AppSpacing.kHeight10,
                        CustomTextField(
                          controller: settingsController.emailController,
                          hintText: 'Email',
                          readOnly: true,
                        ),
                        AppSpacing.kHeight10,
                        Consumer<SettingsController>(builder:
                            (BuildContext context, value, Widget? child) {
                          return value.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CustomButtonWidget(
                                  text: "SAVE",
                                  ontap: () async {
                                    if (settingsController.image != null) {
                                      await settingsController.uploadImage();
                                    }
                                  },
                                );
                        }),
                      ],
                    );
            }),
          ),
        ),
      ),
    );
  }
}
