import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.white, // Ensure the background stays white
        elevation: 3, // Adjust the shadow
        shadowColor: Colors.grey[200], // Soft shadow
        surfaceTintColor:
            Colors.white, // Prevents the background color from changing
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.defaultSize * 2,
        ),
      ));
}
