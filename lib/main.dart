import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/controller/home_controller.dart';
import 'package:firebase_crud/controller/login_controller.dart';
import 'package:firebase_crud/controller/register_controller.dart';
import 'package:firebase_crud/controller/settings_controller.dart';
import 'package:firebase_crud/controller/splash_controller.dart';
import 'package:firebase_crud/controller/student_modify_controller.dart';
import 'package:firebase_crud/firebase_options.dart';
import 'package:firebase_crud/helpers/app_colors.dart';
import 'package:firebase_crud/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashController()),
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => RegisterController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => StudentModifyController()),
        ChangeNotifierProvider(create: (context) => SettingsController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: AppColors.backgroundColor,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
