import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApptextStyle {
  static TextStyle mainTitle = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      overflow: TextOverflow.ellipsis);
  static TextStyle mainContent = TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle date = TextStyle(
      fontSize: 13.sp.sp, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle textButton = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle appBarText = TextStyle(
      fontSize: 22.sp, color: Colors.black, fontWeight: FontWeight.w400);
  static TextStyle smallBlackText = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText14 = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText17 = TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText15 = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle logOutText = TextStyle(fontSize: 14.sp, color: Colors.black);

  //
  static TextStyle bodyHeadline = TextStyle(fontSize: 20.sp);
  static TextStyle bodyNormalText = TextStyle(fontSize: 16.sp);
  static TextStyle imageValidationStyle =
      TextStyle(fontSize: 12.sp, color: Colors.red);
}
