import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mwave/constants/colors.dart';

import 'package:mwave/firebase_options.dart';
import 'package:mwave/onboardvideo/splash_screen.dart';
import 'package:mwave/onboardvideo/video_scree.dart';
import 'package:mwave/view/bottumbar1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(500, 800), // Moto G82 approximate dimensions
        builder: (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: kwhite, // Main purple
              hintColor: const Color(0xFFA166F3), // Accent purple
              scaffoldBackgroundColor: kwhite, // Light background color

              buttonTheme: ButtonThemeData(
                buttonColor: kwhite, // Primary button color
                textTheme: ButtonTextTheme.primary,
              ),

              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFA166F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kblue),
                ),
                fillColor: Colors.white, // Input field background
                filled: true,
              ),

              //  appBarTheme: customAppBarTheme(), // Import your AppBar theme

              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: kblue, // Text color
                ),
              ),

              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.black87),
                bodyMedium: TextStyle(color: Colors.black54),
              ),

              cardTheme: CardTheme(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            home: SplashScreen()));
  }
}
