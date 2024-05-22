import 'package:flutter/material.dart';

ThemeData generateTheme(ThemeMode themeData) {
  late ThemeData theme;
  if (themeData == ThemeMode.light) {
    theme = ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.purple,
        accentColor: Colors.purple,
        cardColor: Colors.red.shade100,
        backgroundColor: Colors.white,
        errorColor: Colors.red.shade800,
      ),
    );
  } else {
    theme = ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.amber,
        accentColor: Colors.deepPurple,
        cardColor: Colors.black45,
        backgroundColor: Colors.black87,
        errorColor: Colors.red.shade400,
        brightness: Brightness.dark,
      ),
    );
  }
  return theme;
}
