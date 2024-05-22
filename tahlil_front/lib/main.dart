import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahlil_front/pages/auth.dart';
import 'package:tahlil_front/pages/home.dart';
import 'package:tahlil_front/services/auth.dart';
import 'package:tahlil_front/utils/theme.dart';

void main() {
  runApp(const TahlilApp());
}

class TahlilApp extends StatefulWidget {
  const TahlilApp({super.key});

  @override
  State<TahlilApp> createState() => _TahlilAppState();
}

class _TahlilAppState extends State<TahlilApp> {
  AuthService authService = AuthService.instance;
  ThemeData lightTheme = generateTheme(ThemeMode.light);
  ThemeData darkTheme = generateTheme(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // theme: lightTheme,
      // darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/auth':
            return GetPageRoute(page: () => const AuthPage());
        }
      },
      home: const HomePage(),
    );
  }
}
