import 'package:flutter/material.dart';

enum AppTheme { dark, light }

final appThemes = {
  AppTheme.light: ThemeData.light().copyWith(
      primaryColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red.withOpacity(0.5)),
      bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade500),
      colorScheme:
          const ColorScheme.light().copyWith(background: Colors.white)),
  AppTheme.dark: ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(selectedItemColor: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.red.withOpacity(0.5)),
    iconTheme: IconThemeData(color: Colors.red.shade400),
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade800),
    colorScheme:
        const ColorScheme.light().copyWith(background: Colors.grey.shade800),
  ),
};
