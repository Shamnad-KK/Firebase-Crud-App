import 'package:firebase_crud/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashController =
        Provider.of<SplashController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 2), () {
        splashController.checkUserState(context);
      });
    });
    return const Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Center(
        child: Image(
            image: AssetImage('assets/NoteThePoint-removebg-preview.png')),
      ),
    );
  }
}
