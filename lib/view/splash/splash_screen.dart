import 'package:firebase_crud/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashController =
        Provider.of<SplashController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      splashController.checkUserState(context);
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
