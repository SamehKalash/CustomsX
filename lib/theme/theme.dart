import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  primaryColor: const Color.fromARGB(255, 211, 174, 9),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color.fromARGB(255, 212, 173, 0),
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.grey),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: const Color.fromARGB(255, 211, 174, 9),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color.fromARGB(255, 212, 162, 0),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  dividerColor: Colors.grey[700],
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white70),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
);
