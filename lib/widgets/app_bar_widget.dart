import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarColor,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
