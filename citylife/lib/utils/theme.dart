import 'package:flutter/material.dart';

class T {
  static final LinearGradient backgroundColor = LinearGradient(
    colors: [
      Color(0xFF87D0AD),
      Color(0xFF00A0AA),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFF005B50),
      Color(0xFF47BCAE),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static final Color primaryColor = Color(0xFF4B9F95);
  static final Color textLightColor = Color(0xFFFFFFDD);
  static final Color textDarkColor = Color(0xFF868686);
  static final Color textFieldIconColor = Color(0xFF5DB075);

  static final ThemeData themeData = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.grey[400],
      ),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: textFieldIconColor, width: 2.0),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
  );

  static final IconThemeData unselectedBottomNavBarIconTheme = IconThemeData(
    color: Colors.black,
    opacity: .54,
  );

  static final IconThemeData selectedBottomNavBarIconTheme = IconThemeData(
    color: Colors.white,
    opacity: .8,
  );
}
