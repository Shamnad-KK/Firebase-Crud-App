import 'package:firebase_crud/repository/splash_repository.dart';
import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  void checkUserState(BuildContext context) {
    SplashRepository().chekAuthState(context);
  }
}
