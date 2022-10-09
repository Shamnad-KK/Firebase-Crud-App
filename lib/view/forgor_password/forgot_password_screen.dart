import 'package:firebase_crud/controller/forgot_password_controller.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/view/home/widgets/custom_textfield.dart';
import 'package:firebase_crud/widgets/app_bar_widget.dart';
import 'package:firebase_crud/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forgotPasswordController =
        Provider.of<ForgotPasswordController>(context, listen: false);
    return Scaffold(
      appBar: const AppBarWidget(title: "Forgot Password"),
      body: SafeArea(
        child: Padding(
          padding: AppPading.mainPading,
          child: Column(
            children: [
              AppSpacing.kHeight40,
              Text(
                "Please enter your email address for resetting your password",
                style: ApptextStyle.blackText15,
              ),
              AppSpacing.kHeight20,
              CustomTextField(
                hintText: "Email",
                controller: forgotPasswordController.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              AppSpacing.kHeight20,
              Consumer<ForgotPasswordController>(
                builder: (BuildContext context, value, Widget? child) {
                  return value.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                          ),
                        )
                      : SizedBox(
                          width: 200.w,
                          child: CustomButtonWidget(
                            text: "CONFIRM",
                            ontap: () async {
                              await forgotPasswordController
                                  .resetPassword(context);
                            },
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
