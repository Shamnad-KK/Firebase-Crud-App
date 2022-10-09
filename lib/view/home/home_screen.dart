import 'dart:developer';

import 'package:firebase_crud/constants/enums.dart';
import 'package:firebase_crud/controller/note_modify_controller.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/helpers/text_style.dart';
import 'package:firebase_crud/view/settings/settings_screen.dart';
import 'package:firebase_crud/view/note_modify/note_modify_screen.dart';
import 'package:firebase_crud/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteController =
        Provider.of<NoteModifyController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await noteController.fetchAllNotes();
    });
    return Scaffold(
      appBar: AppBarWidget(
        title: "",
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<NoteModifyController>(
                  builder: (context, value, child) {
                if (value.isLoading == true) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  );
                } else if (value.noteList == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  );
                } else if (value.noteList!.isEmpty) {
                  return const Center(
                    child: Text("Add notes"),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: GridView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: value.noteList?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          final note = value.noteList![index];
                          log(note.uid);
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => StudentModifyScreen(
                                    type: ScreenAction.editScreen,
                                    note: note,
                                  ),
                                ),
                              );
                            },
                            child: Container(
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
                                  ),
                                  AppSpacing.kHeight8,
                                  Text(
                                    value.formatDate(note.date!),
                                    style: ApptextStyle.date,
                                  ),
                                  AppSpacing.kHeight8,
                                  Text(
                                    note.noteContent == ""
                                        ? "No content"
                                        : note.noteContent!,
                                    style: ApptextStyle.mainContent,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                  // ListView.builder(
                  //     itemCount: value.noteList!.length,
                  //     itemBuilder: (context, index) {
                  //       final student = value.noteList![index];
                  //       return Column(
                  //         children: [
                  //           AppSpacing.kHeight10,
                  //           InkWell(
                  //             onTap: () {
                  //               Navigator.of(context).push(MaterialPageRoute(
                  //                 builder: (ctx) => StudentModifyScreen(
                  //                   type: ScreenAction.editScreen,
                  //                   student: student,
                  //                 ),
                  //               ));
                  //             },
                  //             child: ListTile(
                  //               leading: CircleAvatar(
                  //                 radius: 30,
                  //                 backgroundImage:
                  //                     NetworkImage(student.profilePic),
                  //               ),
                  //               title: Text(student.name),
                  //               subtitle: Text(student.domain),
                  //               trailing: IconButton(
                  //                   onPressed: () async {
                  //                     await studentController.deleteStudent(
                  //                         student.uid, context);
                  //                     // studentController.noteList!
                  //                     //     .removeAt(index);
                  //                   },
                  //                   icon: const Icon(
                  //                     Icons.delete,
                  //                     color: Colors.red,
                  //                   )),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     });
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const StudentModifyScreen(
                type: ScreenAction.addScreen,
              ),
            ),
          );
        },
      ),
    );
  }
}
