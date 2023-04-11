// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

enum AppTheme { dark, light }

final appThemes = {
  AppTheme.light: ThemeData.light().copyWith(
      primaryColor: Colors.white,
      backgroundColor: Colors.white,
      bottomAppBarColor: Colors.grey.shade500,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red.withOpacity(0.5))),
  AppTheme.dark: ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    backgroundColor: Colors.grey.shade800,
    bottomAppBarColor: Colors.grey.shade800,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(selectedItemColor: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.red.withOpacity(0.5)),
    iconTheme: IconThemeData(color: Colors.red.shade400),
  ),
};
