import 'package:firebase_crud/constants/enums.dart';
import 'package:firebase_crud/controller/note_modify_controller.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/helpers/app_padding.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/model/note_model.dart';
import 'package:firebase_crud/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteModifyScreen extends StatelessWidget {
  const NoteModifyScreen({
    super.key,
    required this.type,
    this.note,
  });
  final ScreenAction type;
  final NoteModel? note;

  @override
  Widget build(BuildContext context) {
    final noteModifyController =
        Provider.of<NoteModifyController>(context, listen: false);
    noteModifyController.valueAssign(type, note);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (type == ScreenAction.addScreen) {
        // noteModifyController.shuffleColor();
      }
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: type == ScreenAction.addScreen ? "Add Note" : "Edit Note",
        color: type == ScreenAction.addScreen
            ? AppColors.cardColors[noteModifyController.colorId]
            : AppColors.cardColors[note!.colorId!],
      ),
      backgroundColor: type == ScreenAction.addScreen
          ? AppColors.cardColors[noteModifyController.colorId]
          : AppColors.cardColors[note!.colorId!],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: AppPading.mainPading,
            child: Consumer<NoteModifyController>(
                builder: (BuildContext context, value, Widget? child) {
              return value.isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: noteModifyController.titleController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Note title ..'),
                          style: ApptextStyle.mainTitle,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          noteModifyController.date ?? "",
                          style: ApptextStyle.date,
                        ),
                        SizedBox(height: 28.h),
                        TextFormField(
                          controller: noteModifyController.contentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Note content',
                          ),
                          style: ApptextStyle.mainContent,
                        ),
                      ],
                    );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.mainColor,
        label: const Text(
          'Save',
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(
          Icons.save,
          color: Colors.black,
        ),
        onPressed: () async {
          if (type == ScreenAction.addScreen) {
            noteModifyController.addNote(context);
          } else {
            noteModifyController.updateNote(context, note!.uid, note!.colorId!);
          }
        },
      ),
    );
  }
}
