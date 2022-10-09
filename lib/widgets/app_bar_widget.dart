import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget(
      {super.key,
      required this.title,
      this.color = AppColors.mainColor,
      this.actions});
  final String title;
  final Color color;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      elevation: 0,
      title: Text(
        title,
        style: ApptextStyle.appBarText,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60.h);
}
