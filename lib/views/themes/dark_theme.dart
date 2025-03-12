import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';

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
      surfaceTintColor:
            Colors.black, // Prevents the background color from changing
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: SizeConfig.defaultSize * 2 ,
      )
    ),
  );
}
