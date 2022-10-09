import 'dart:developer';

import 'package:firebase_crud/constants/enums.dart';
import 'package:firebase_crud/controller/home_controller.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/view/home/widgets/delete_icon_widget.dart';
import 'package:firebase_crud/view/home/widgets/note_card_widget.dart';
import 'package:firebase_crud/view/note_modify/note_modify_screen.dart';
import 'package:firebase_crud/view/settings/settings_screen.dart';
import 'package:firebase_crud/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await homeController.fetchAllNotes();
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
              child: Consumer<HomeController>(builder: (context, value, child) {
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.2,
                          crossAxisSpacing: 5.w,
                          mainAxisSpacing: 5.h,
                        ),
                        itemBuilder: (context, index) {
                          final note = value.noteList![index];
                          log(note.uid);
                          return GestureDetector(
                            onLongPress: () {
                              homeController.setDeleteOpacity(1);
                              homeController.setDeleteColor(note.colorId);
                            },
                            onLongPressEnd: (details) {
                              homeController.setDeleteOpacity(0);
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => NoteModifyScreen(
                                    type: ScreenAction.editScreen,
                                    note: note,
                                  ),
                                ),
                              );
                            },
                            child: Draggable(
                              maxSimultaneousDrags: 1,
                              data: note,
                              onDragStarted: () {
                                value.deleteUid = note.uid;
                                homeController.setDeleteColor(note.colorId);
                                homeController.setDeleteOpacity(1);
                              },
                              onDraggableCanceled: (velocity, offset) {
                                homeController.setDeleteOpacity(0);
                              },
                              feedback: SizedBox(
                                height: 200.h,
                                width: 200.w,
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Material(
                                    child: NoteCardWidget(
                                      note: note,
                                      value: value,
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: value.noteList!.length > 1
                                  ? NoteCardWidget(
                                      note: note,
                                      value: value,
                                    )
                                  : const SizedBox(),
                              child: NoteCardWidget(
                                note: note,
                                value: value,
                              ),
                            ),
                          );
                        }),
                  );
                }
              }),
            ),
            const DeleteIconWidget()
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
              builder: (ctx) => const NoteModifyScreen(
                type: ScreenAction.addScreen,
              ),
            ),
          );
        },
      ),
    );
  }
}
