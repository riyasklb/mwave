import 'package:flutter/material.dart';

final kwhite = Colors.white;
final kblack = Colors.black;
final kblue = Color(0xFF7E57C2);
AppBarTheme customAppBarTheme() {
  return const AppBarTheme(
    color: Color(0xFF6A00D7), // Purple app bar
    iconTheme: IconThemeData(color: Colors.white), // Icon theme
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  );
}

SizedBox kheight40 = SizedBox(
  height: 40,
);

// A sample base64 string of an image (replace this with your actual base64 string)
const String custombagroundimage = 'assets/images/pixelcut-export 3(1).jpeg';
Image bagroundimage = Image.asset(custombagroundimage);
