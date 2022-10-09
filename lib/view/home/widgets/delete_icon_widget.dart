import 'package:firebase_crud/controller/home_controller.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/utils/app_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteIconWidget extends StatelessWidget {
  const DeleteIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
        builder: (BuildContext context, values, Widget? child) {
      return DragTarget<NoteModel>(onWillAccept: (NoteModel? note) {
        return true;
      }, onAccept: (data) {
        AppPopUps().showAlertBox(
          context,
          "delete",
          ontap: () async {
            values.setDeleteOpacity(0);
            await values.deleteNote(values.deleteUid!);
            values.removeFromList(data);
          },
        );
      }, builder: (
        BuildContext context,
        List<Object?> _,
        List<dynamic> __,
      ) {
        return AnimatedOpacity(
          opacity: values.opacity,
          curve: Curves.easeInCubic,
          onEnd: () {
            // log("message");
          },
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: AppPading.mainPading,
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: AppColors.cardColors[values.colorId ?? 0],
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 35.h,
              ),
            ),
          ),
        );
      });
    });
  }
}
