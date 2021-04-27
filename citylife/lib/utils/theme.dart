import 'package:flutter/material.dart';

class T {
  static final LinearGradient backgroundColor = LinearGradient(
    colors: [
      Color(0xFF87D0AD),
      Color(0xFF00A0AA).withOpacity(0.1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFF005B50),
      Color(0xFF005B50),
      Color(0xFF005B50),
      Color(0xFF47BCAE),
      Color(0xFF47BCAE),
      Color(0xFF47BCAE),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static final LinearGradient avatarBorderGradient = LinearGradient(
    colors: [
      Colors.amber[200],
      Colors.yellow[700],
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static final LinearGradient sliderTrackGradient = LinearGradient(
    colors: [
      Color(0xFF3AAB75),
      Color(0xFF28A5AD),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final Color primaryColor = Color(0xFF4B9F95);
  static final Color textLightColor = Color(0xFFFFFFDD);
  static final Color textDarkColor = Color(0xFF868686);
  static final Color textFieldIconColor = Color(0xFF5DB075);
  static final Color structuralColor = Color(0xFF247772);
  static final Color emotionalColor = Color(0xFF16A9A0);

  static final ThemeData themeData = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: T.textDarkColor,
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
      labelStyle: TextStyle(
        color: T.textDarkColor,
        fontSize: 16,
      ),
      fillColor: Colors.grey[100],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: textFieldIconColor, width: 2.0),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
    snackBarTheme: SnackBarThemeData(
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(20.0),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: T.structuralColor,
      contentTextStyle: TextStyle(
        fontSize: 18.0,
      ),
      elevation: 10,
      actionTextColor: T.textLightColor,
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
