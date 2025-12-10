import 'package:flutter/material.dart';

ThemeData themeDataLight = ThemeData(
  primaryColor: const Color(0xFF0087BD), // Sea Blue
  scaffoldBackgroundColor: Colors.white, // White background
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF0087BD), // Sea Blue AppBar
    iconTheme: const IconThemeData(color: Colors.white), // White icon on AppBar
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF0087BD), // Sea Blue button color
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    displayLarge: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF0F0F0), // Light grey background for TextFields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.black12),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0087BD), width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0087BD), width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF0087BD), // Sea Blue FAB
  ),
  iconTheme: const IconThemeData(
    color: Colors.black, // Default icon color
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF0087BD), // Sea Blue
    secondary: const Color(0xFF0087BD), // Sea Blue
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
  ),
);

ThemeData themeDataDark = ThemeData(
  primaryColor: const Color(0xFF0087BD), // Sea Blue
  scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF121212), // Dark AppBar
    iconTheme: const IconThemeData(color: Colors.white), // White icon on AppBar
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF0087BD), // Sea Blue button color
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF333333), // Dark grey background for TextFields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.white38),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0087BD), width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0087BD), width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF0087BD), // Sea Blue FAB
  ),
  iconTheme: const IconThemeData(
    color: Colors.white, // White icon color
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF0087BD), // Sea Blue
    secondary: const Color(0xFF0087BD), // Sea Blue
    surface: const Color(0xFF121212), // Dark surface
    background: const Color(0xFF121212), // Dark background
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
  ),
);
