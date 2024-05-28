import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tahlil_front/pages/appointments.dart';
import 'package:tahlil_front/pages/auth.dart';
import 'package:tahlil_front/pages/profile.dart';
import 'package:tahlil_front/pages/verification.dart';
import 'package:tahlil_front/services/auth.dart';
import 'package:tahlil_front/services/profile.dart';
import 'package:tahlil_front/services/router.dart';
import 'package:tahlil_front/utils/theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

void main() {
  runApp(TahlilApp());
}

class TahlilApp extends StatelessWidget {
  static final AuthService _authService = AuthService.instance;
  static final ProfileService _profileService = ProfileService.instance;

  final ThemeData _lightTheme = generateTheme(ThemeMode.light);
  final ThemeData _darkTheme = generateTheme(ThemeMode.dark);

  final _router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
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
                        onPressed: () => RouterService.go('/auth'),
                        label: const Text('Register / Login'),
                        icon: const FaIcon(FontAwesomeIcons.rightToBracket),
                      );
                    }
                    return TextButton.icon(
                      onPressed: () => RouterService.go('/profile'),
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
                  child: Image.asset('assets/doctor.png'),
                )
              ],
            ),
          ),
          body: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            redirect: (context, state) async {
              if (!(await _authService.isLoggedIn())) return '/auth';
              final profile = await _profileService.profile;
              if (profile == null) return '/auth';
              if (profile.isReferrer) return '/verification';
              return '/appointments';
            },
            routes: [
              GoRoute(
                path: 'auth',
                redirect: needsNoAuthRedirect,
                builder: (context, state) => const AuthPage(),
              ),
              GoRoute(
                path: 'profile',
                redirect: needsAuthRedirect,
                builder: (context, state) => const ProfilePage(),
              ),
              GoRoute(
                path: 'verification',
                redirect: needsAuthRedirect,
                builder: (context, state) => const VerificationPage(),
              ),
              GoRoute(
                path: 'appointments',
                redirect: needsAuthRedirect,
                builder: (context, state) => const AppointmentsPage(),
              ),
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
      // theme: _lightTheme,
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
    if (await _authService.isLoggedIn()) return null;
    return 'auth';
  }

  static FutureOr<String?> needsNoAuthRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (!(await _authService.isLoggedIn())) return null;
    return '/';
  }
}
