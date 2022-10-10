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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      registerController.setLoading(false);
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppBarWidget(title: ''),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: AppPading.mainPading,
          child: Center(
            child: Form(
              key: registerController.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 7,
                  ),
                  CustomTextField(
                      controller: registerController.usernameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        return registerController.userNameValidation();
                      },
                      hintText: 'Username'),
                  AppSpacing.kHeight10,
                  CustomTextField(
                      controller: registerController.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return registerController.emailValidation();
                      },
                      hintText: 'Email'),
                  AppSpacing.kHeight10,
                  Consumer<RegisterController>(
                      builder: (BuildContext context, value, Widget? child) {
                    return CustomTextField(
                      controller: registerController.passController,
                      keyboardType: TextInputType.text,
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
                      keyboardType: TextInputType.text,
                      hintText: 'Confirm Password',
                      isPassword: true,
                      obscure: value.rePassObscure,
                      suffixOntap: () {
                        registerController.setRetypePasswordObscure();
                      },
                    );
                  }),
                  AppSpacing.kHeight40,
                  Consumer<RegisterController>(
                      builder: (BuildContext context, value, Widget? child) {
                    return value.isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : CustomButtonWidget(
                            text: 'SIGN UP',
                            ontap: () async {
                              if (registerController.formKey.currentState!
                                  .validate()) {
                                await registerController.signUpUser(context);
                              }
                            },
                          );
                  }),
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
