import 'package:flutter/material.dart';

class ApptextStyle {
  static TextStyle mainTitle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      overflow: TextOverflow.ellipsis);
  static TextStyle mainContent = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle date = const TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle textButton = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle appBarText =
      TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w400);
  static TextStyle smallBlackText = const TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText14 = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText17 = const TextStyle(
      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText15 = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle logOutText =
      const TextStyle(fontSize: 14, color: Colors.black);

  //
  static const TextStyle bodyHeadline = TextStyle(fontSize: 20);
  static const TextStyle bodyNormalText = TextStyle(fontSize: 16);
  static const TextStyle imageValidationStyle =
      TextStyle(fontSize: 12, color: Colors.red);
}
