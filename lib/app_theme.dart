import 'package:flutter/material.dart';

class AppTheme {
  static Color seedColor = Colors.teal;

  static ThemeData getBaseTheme({Brightness? brightness}) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: brightness ?? Brightness.light,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
      ),
    ),
  );

  static ThemeData get lightTheme => getBaseTheme();

  static ThemeData get darkTheme => getBaseTheme(brightness: Brightness.dark);
}
