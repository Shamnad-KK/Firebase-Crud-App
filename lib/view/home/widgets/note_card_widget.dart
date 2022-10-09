import 'package:firebase_crud/controller/home_controller.dart';
import 'package:firebase_crud/controller/note_modify_controller.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:flutter/material.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.value,
  }) : super(key: key);

  final NoteModel note;
  final HomeController value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cardColors[note.colorId!],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title == "" ? "No title" : note.title!,
            style: ApptextStyle.mainTitle,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.kHeight20,
          Text(
            value.formatDate(note.date!),
            style: ApptextStyle.date,
          ),
          AppSpacing.kHeight8,
          Expanded(
            child: Text(
              note.noteContent == "" ? "No content" : note.noteContent!,
              style: ApptextStyle.mainContent,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
