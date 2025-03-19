import 'package:flutter/material.dart';
import 'package:chatapp/views/widgets/sizeconig.dart';

class DarkTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.blueGrey,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.blueGrey,
      unselectedItemColor: Colors.grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      shadowColor: Colors.grey[100],
      elevation: 3,
      surfaceTintColor: Colors.black, // Prevents background color from changing
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: SizeConfig.defaultSize * 2,
      ),
    ),
    
    // ✅ TextField Styling
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900], // Background color of the TextField
      hintStyle: TextStyle(color: Colors.grey[500]), // Hint text color
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:const BorderSide(color: Colors.blueGrey),
      ),
    ),
  );
}
