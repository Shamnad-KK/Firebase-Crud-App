import 'dart:io';

import 'package:firebase_crud/controller/student_modify_controller.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/view/home/widgets/custom_textfield.dart';
import 'package:firebase_crud/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentModifyScreen extends StatelessWidget {
  const StudentModifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentController =
        Provider.of<StudentModifyController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: AppPading.mainPading,
            child: Form(
              key: studentController.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSpacing.kHeight40,
                  Stack(
                    children: [
                      Consumer<StudentModifyController>(builder:
                          (BuildContext context, value, Widget? child) {
                        return value.image == null
                            ? const CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png",
                                ))
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    FileImage(File(value.image!.path)),
                              );
                      }),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                          onPressed: () {
                            studentController.pickImage();
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                      )
                    ],
                  ),
                  AppSpacing.kHeight10,
                  Consumer<StudentModifyController>(
                    builder: (BuildContext context, value, Widget? child) {
                      return Visibility(
                          visible: value.imageValidation,
                          child: const Text(
                            "Please add an image",
                            style: ApptextStyle.imageValidationStyle,
                          ));
                    },
                  ),
                  AppSpacing.kHeight40,
                  CustomTextField(
                    hintText: "Student name",
                    controller: studentController.nameController,
                    validator: (value) {
                      return studentController.nameValidation();
                    },
                  ),
                  AppSpacing.kHeight10,
                  CustomTextField(
                    hintText: "Mobile",
                    controller: studentController.mobileContoller,
                    validator: (value) {
                      return studentController.mobileValidation();
                    },
                  ),
                  AppSpacing.kHeight10,
                  CustomTextField(
                    hintText: "Age",
                    controller: studentController.ageController,
                    validator: (value) {
                      return studentController.ageValidation();
                    },
                  ),
                  AppSpacing.kHeight10,
                  CustomTextField(
                    hintText: "Domain",
                    controller: studentController.domainController,
                    validator: (value) {
                      return studentController.domainValidation();
                    },
                  ),
                  AppSpacing.kHeight10,
                  AppSpacing.kHeight10,
                  CustomButtonWidget(
                    text: 'CONTINUE',
                    ontap: () async {
                      studentController.setImageValidation();
                      if (studentController.formKey.currentState!.validate()) {
                        await studentController.saveStudentData(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
