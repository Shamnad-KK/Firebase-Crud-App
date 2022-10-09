import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/controller/forgot_password_controller.dart';
import 'package:firebase_crud/controller/home_controller.dart';
import 'package:firebase_crud/controller/login_controller.dart';
import 'package:firebase_crud/controller/register_controller.dart';
import 'package:firebase_crud/controller/settings_controller.dart';
import 'package:firebase_crud/controller/splash_controller.dart';
import 'package:firebase_crud/controller/note_modify_controller.dart';
import 'package:firebase_crud/firebase_options.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => SplashController()),
              ChangeNotifierProvider(create: (context) => LoginController()),
              ChangeNotifierProvider(create: (context) => RegisterController()),
              ChangeNotifierProvider(create: (context) => HomeController()),
              ChangeNotifierProvider(
                  create: (context) => NoteModifyController()),
              ChangeNotifierProvider(create: (context) => SettingsController()),
              ChangeNotifierProvider(
                  create: (context) => ForgotPasswordController()),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                scaffoldBackgroundColor: AppColors.mainColor,
                appBarTheme: const AppBarTheme(
                    iconTheme: IconThemeData(
                  color: Colors.black,
                )),
              ),
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
            ),
          );
        });
  }
}
