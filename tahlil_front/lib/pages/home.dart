import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tahlil_front/pages/auth.dart';
import 'package:tahlil_front/pages/explore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Pezeshkan-sharif'),
        actions: [
          TextButton.icon(
            onPressed: () => Get.toNamed('/auth'),
            label: const Text('Sign Up / Login'),
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
      body: Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          print('${settings.name}, ${settings.arguments}');
          switch (settings.name) {
            case '/':
              return GetPageRoute(page: () => const ExplorePage());
          }
        },
      ),
    );
  }
}
