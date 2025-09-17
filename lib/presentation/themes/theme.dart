import 'package:flutter/material.dart';

class AppTheme {
  static const Color buttonColor = Color.fromARGB(255, 90, 74, 227);
  static const Color lightGray = Color(0xFFF2F2F2);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212); // ana arka plan
  static const Color darkCard = Color(0xFF1E1E1E); // kartlar için koyu gri
  static const Color darkGray = Color(0xFF2C2C2C); // buton/secondary alan için
  static const Color lightText = Colors.white; // yazılar için
  static const Color subText = Color(0xFFB3B3B3); // ikincil yazılar

  static final lighttheme = ThemeData(
    scaffoldBackgroundColor: white,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.buttonColor,
        foregroundColor: AppTheme.white,
        textStyle: const TextStyle(fontSize: 20),
      ),
    ),

    //email password gbi textfieldler için
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppTheme.lightGray,
      contentPadding: EdgeInsets.only(left: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final darktheme = ThemeData(
    appBarTheme: AppBarThemeData(
      backgroundColor: AppTheme.darkBackground,
      titleTextStyle: TextStyle(
        color: AppTheme.lightGray,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppTheme.lightText),
    ),
    scaffoldBackgroundColor: darkBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.subText,
        foregroundColor: AppTheme.black,
        textStyle: const TextStyle(fontSize: 20),
      ),
    ),

    //email password gbi textfieldler için
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.only(left: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
