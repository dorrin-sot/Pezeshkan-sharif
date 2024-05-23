import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:tahlil_front/enums/toast_type.dart';
import 'package:tahlil_front/main.dart';
import 'package:tahlil_front/services/auth.dart';
import 'package:tahlil_front/utils/pair.dart';
import 'package:tahlil_front/widgets/toast.dart';

class ProfilePage extends StatelessWidget {
  final _authService = AuthService.instance;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: _logout,
          label: const Text('Logout'),
        ),
      ],
    );
  }

  Future<void> _logout() async => _postSubmit(await _authService.logout());

  void _postSubmit(Pair<bool, String> response) {
    final toast = FToast();
    toast.init(rootNavigatorKey.currentContext!);
    toast.showToast(
      child: CustomToast(
        text: response.second,
        toastType: response.first ? ToastType.success : ToastType.error,
      ),
      gravity: ToastGravity.BOTTOM_LEFT,
    );
    if (response.first) GoRouter.of(shellNavigatorKey.currentContext!).go('/');
  }
}
