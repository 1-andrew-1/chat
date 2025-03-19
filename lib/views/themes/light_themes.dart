import 'package:flutter/material.dart';
import 'package:chatapp/views/widgets/sizeconig.dart';

class LightTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blue,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white, // Ensure background stays white
      elevation: 3, // Adjust the shadow
      shadowColor: Colors.grey[200], // Soft shadow
      surfaceTintColor: Colors.white, // Prevents background color change
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: SizeConfig.defaultSize * 2,
      ),
    ),

    // ✅ TextField Styling
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200], // Light grey background for text field
      hintStyle: TextStyle(color: Colors.grey[600]), // Darker hint text
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromARGB(255, 171, 207, 236), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    ),
  );
}
