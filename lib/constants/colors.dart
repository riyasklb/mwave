import 'package:flutter/material.dart';

final kwhite=Colors.white;
final kblack=Colors.black;
final kblue=Color(0xFF7E57C2);
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
