import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF111827));
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFFF6F7FB),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
