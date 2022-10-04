import 'package:firebase_crud/controller/login_controller.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/view/home/widgets/custom_textfield.dart';
import 'package:firebase_crud/view/register/register_screen.dart';
import 'package:firebase_crud/widgets/app_bar_widget.dart';
import 'package:firebase_crud/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController =
        Provider.of<LoginController>(context, listen: false);
    return Scaffold(
      appBar: const AppBarWidget(title: 'Login'),
      body: SafeArea(
        child: Padding(
          padding: AppPading.mainPading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Log In', style: ApptextStyle.bodyHeadline),
              AppSpacing.kHeight10,
              CustomTextField(
                  controller: loginController.emailController,
                  hintText: 'Email'),
              AppSpacing.kHeight10,
              Consumer<LoginController>(
                  builder: (BuildContext context, value, Widget? child) {
                return CustomTextField(
                  controller: loginController.passController,
                  hintText: 'Password',
                  isPassword: true,
                  obscure: value.passObscure,
                  suffixOntap: () {
                    loginController.setPasswordObscure();
                  },
                );
              }),
              AppSpacing.kHeight10,
              CustomButtonWidget(
                text: 'CONTINUE',
                ontap: () async {
                  await loginController.login(context);
                },
              ),
              AppSpacing.kHeight10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New user ?',
                    style: ApptextStyle.bodyNormalText,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: ApptextStyle.bodyNormalText,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
