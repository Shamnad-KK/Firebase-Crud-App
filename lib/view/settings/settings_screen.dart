import 'dart:developer';

import 'package:firebase_crud/controller/settings_controller.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:firebase_crud/view/home/widgets/custom_textfield.dart';
import 'package:firebase_crud/widgets/app_bar_widget.dart';
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
      settingsController.userName = settingsController.usernameController.text;
      settingsController.email = settingsController.emailController.text;
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        title: "",
        actions: [
          IconButton(
            onPressed: () async {
              settingsController.signOut(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: AppPading.mainPading,
            child: Column(
              verticalDirection: VerticalDirection.down,
              children: [
                Consumer<SettingsController>(
                    builder: (BuildContext context, value, Widget? child) {
                  return value.isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Image(
                                  image: AssetImage(
                                    'assets/NoteThePoint-removebg-preview.png',
                                  ),
                                ),
                                CustomTextField(
                                  controller:
                                      settingsController.usernameController,
                                  hintText: 'Username',
                                  keyboardType: TextInputType.name,
                                ),
                                AppSpacing.kHeight10,
                                CustomTextField(
                                  controller:
                                      settingsController.emailController,
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                AppSpacing.kHeight40,
                                Consumer<SettingsController>(builder:
                                    (BuildContext context, value,
                                        Widget? child) {
                                  return value.buttonLoading == true
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : CustomButtonWidget(
                                          text: "SAVE",
                                          ontap: () async {
                                            if (value.userName !=
                                                    value.usernameController
                                                        .text ||
                                                value.email !=
                                                    value
                                                        .emailController.text) {
                                              settingsController
                                                  .updateUserData(context);
                                            } else {
                                              AppPopUps().showToast(
                                                  "Already up-to-date",
                                                  Colors.green);
                                            }
                                          },
                                        );
                                }),
                              ],
                            ),
                          ],
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
