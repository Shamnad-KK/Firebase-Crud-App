import 'package:firebase_crud/controller/register_controller.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/view/home/widgets/custom_textfield.dart';
import 'package:firebase_crud/widgets/app_bar_widget.dart';
import 'package:firebase_crud/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerController =
        Provider.of<RegisterController>(context, listen: false);
    return Scaffold(
      appBar: const AppBarWidget(title: 'Register'),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPading.mainPading,
          child: Center(
            child: Form(
              key: registerController.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // AppSpacing.kHeight40,
                  // Stack(
                  //   children: [
                  //     Consumer<RegisterController>(builder:
                  //         (BuildContext context, value, Widget? child) {
                  //       return value.image == null
                  //           ? const CircleAvatar(
                  //               radius: 50,
                  //               backgroundImage: NetworkImage(
                  //                 "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png",
                  //               ))
                  //           : CircleAvatar(
                  //               radius: 50,
                  //               backgroundImage:
                  //                   FileImage(File(value.image!.path)),
                  //             );
                  //     }),
                  //     Positioned(
                  //       bottom: -10,
                  //       right: -10,
                  //       child: IconButton(
                  //         onPressed: () {
                  //           registerController.pickImage();
                  //         },
                  //         icon: const Icon(Icons.camera_alt),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // AppSpacing.kHeight10,
                  // Visibility(
                  //     visible:
                  //         context.watch<RegisterController>().imageValidation,
                  //     child: const Text(
                  //       "Please add an image",
                  //       style: ApptextStyle.imageValidationStyle,
                  //     )),
                  // AppSpacing.kHeight40,
                  CustomTextField(
                      controller: registerController.usernameController,
                      validator: (value) {
                        return registerController.userNameValidation();
                      },
                      hintText: 'Username'),
                  AppSpacing.kHeight10,
                  CustomTextField(
                      controller: registerController.emailController,
                      validator: (value) {
                        return registerController.emailValidation();
                      },
                      hintText: 'Email'),
                  AppSpacing.kHeight10,
                  Consumer<RegisterController>(
                      builder: (BuildContext context, value, Widget? child) {
                    return CustomTextField(
                      controller: registerController.passController,
                      validator: (value) {
                        return registerController.passwordValidation();
                      },
                      hintText: 'Password',
                      isPassword: true,
                      obscure: value.passObscure,
                      suffixOntap: () {
                        registerController.setPasswordObscure();
                      },
                    );
                  }),
                  AppSpacing.kHeight10,
                  Consumer<RegisterController>(
                      builder: (BuildContext context, value, Widget? child) {
                    return CustomTextField(
                      validator: (value) {
                        return registerController.retypePasswordValidation();
                      },
                      controller: registerController.retypePassController,
                      hintText: 'Confirm Password',
                      isPassword: true,
                      obscure: value.rePassObscure,
                      suffixOntap: () {
                        registerController.setRetypePasswordObscure();
                      },
                    );
                  }),
                  AppSpacing.kHeight10,
                  CustomButtonWidget(
                    text: 'CONTINUE',
                    ontap: () async {
                      if (registerController.formKey.currentState!.validate()) {
                        await registerController.signUpUser(context);
                      }
                    },
                  ),
                  AppSpacing.kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account ?',
                        style: ApptextStyle.bodyNormalText,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Log in',
                            style: ApptextStyle.bodyNormalText,
                          )),
                    ],
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
