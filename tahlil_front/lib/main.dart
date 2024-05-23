import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tahlil_front/pages/auth.dart';
import 'package:tahlil_front/pages/home.dart';
import 'package:tahlil_front/pages/profile.dart';
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
              FutureBuilder<bool>(
                  future: AuthService.instance.isLoggedIn(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    if (snapshot.hasError || !snapshot.data!) {
                      return TextButton.icon(
                        onPressed: () => GoRouter.of(context).go('/auth'),
                        label: const Text('Register / Login'),
                        icon: const FaIcon(FontAwesomeIcons.rightToBracket),
                      );
                    }
                    return TextButton.icon(
                      onPressed: () => GoRouter.of(context).go('/profile'),
                      label: const Text('Profile'),
                      icon: const FaIcon(FontAwesomeIcons.user),
                    );
                  }),
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
                redirect: needsNoAuthRedirect,
                builder: (context, state) => const AuthPage(),
              ),
              GoRoute(
                path: 'profile',
                redirect: needsAuthRedirect,
                builder: (context, state) => ProfilePage(),
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

  static FutureOr<String?> needsAuthRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (await AuthService.instance.isLoggedIn()) return null;
    return 'auth';
  }

  static FutureOr<String?> needsNoAuthRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (!(await AuthService.instance.isLoggedIn())) return null;
    return '/';
  }
}
