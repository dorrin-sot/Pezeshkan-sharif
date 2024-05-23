import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tahlil_front/pages/auth.dart';
import 'package:tahlil_front/pages/home.dart';
import 'package:tahlil_front/services/auth.dart';
import 'package:tahlil_front/utils/theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

void main() {
  runApp(TahlilApp());
}

class TahlilApp extends StatelessWidget {
  final AuthService _authService = AuthService.instance;
  final ThemeData _lightTheme = generateTheme(ThemeMode.light);
  final ThemeData _darkTheme = generateTheme(ThemeMode.dark);

  final _router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Pezeshkan-sharif'),
            actions: [
              TextButton.icon(
                onPressed: () => GoRouter.of(context).go('/auth'),
                label: const Text('Register / Login'),
                icon: const FaIcon(FontAwesomeIcons.rightToBracket),
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Image.asset('assets/Online Doctor-rafiki.png'),
                )
              ],
            ),
          ),
          body: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: 'auth',
                redirect: (context, state) async {
                  if (await AuthService.instance.isLoggedIn()) return '/';
                  return null;
                },
                builder: (context, state) => const AuthPage(),
              )
            ],
          ),
        ],
      )
    ],
  );

  TahlilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // theme: lightTheme,
      // darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      builder: FToastBuilder(),
    );
  }
}
