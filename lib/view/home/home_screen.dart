import 'package:firebase_crud/constants/enums.dart';
import 'package:firebase_crud/controller/student_modify_controller.dart';
import 'package:firebase_crud/helpers/app_spacings.dart';
import 'package:firebase_crud/view/settings/settings_screen.dart';
import 'package:firebase_crud/view/student_modify/student_modify_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentController =
        Provider.of<StudentModifyController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await studentController.fetchAllStudents();
    });
    return Scaffold(
      appBar: AppBar(
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
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Consumer<StudentModifyController>(
                    builder: (context, value, child) {
                  if (value.isLoading == true) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                    );
                  } else if (value.studentList == null ||
                      value.studentList!.isEmpty) {
                    return const Center(
                      child: Text("No students"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: value.studentList!.length,
                        itemBuilder: (context, index) {
                          final student = value.studentList![index];
                          return Column(
                            children: [
                              AppSpacing.kHeight10,
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => StudentModifyScreen(
                                      type: ScreenAction.editScreen,
                                      student: student,
                                    ),
                                  ));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(student.profilePic),
                                  ),
                                  title: Text(student.name),
                                  subtitle: Text(student.domain),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        await studentController
                                            .deleteStudent(student.uid);
                                        // studentController.studentList!
                                        //     .removeAt(index);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                            ],
                          );
                        });
                  }
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
