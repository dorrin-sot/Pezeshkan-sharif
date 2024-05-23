import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tahlil_front/enums/toast_type.dart';
import 'package:tahlil_front/enums/user_type.dart';
import 'package:tahlil_front/main.dart';
import 'package:tahlil_front/services/auth.dart';
import 'package:tahlil_front/widgets/text_field.dart';
import 'package:tahlil_front/widgets/toast.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _authService = AuthService.instance;

  bool _isLogin = true, _passwordShown = false;
  UserType _userType = UserType.referrer;
  final _ssidController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _medicalIdController = TextEditingController();
  final _birthdateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          // color: Colors.red.shade100,
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 2)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        _isLogin ? 'Login' : 'Register',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                if (!_isLogin)
                  SegmentedButton<UserType>(
                    segments: UserType.values
                        .map((ut) => ButtonSegment(
                              value: ut,
                              label: Text('$ut'),
                            ))
                        .toList(),
                    selected: <UserType>{_userType},
                    onSelectionChanged: (newUserType) => setState(() {
                      _userType = newUserType.last;
                    }),
                  ),
                const SizedBox(height: 10),
                CustomTextField(
                  icon: const FaIcon(FontAwesomeIcons.idCard),
                  label: 'SSID',
                  required: true,
                  controller: _ssidController,
                  hint: 'e.g. 1234567890',
                ),
                if (!_isLogin) ...[
                  CustomTextField(
                    icon: const FaIcon(Icons.abc),
                    label: 'First Name',
                    required: true,
                    controller: _firstNameController,
                  ),
                  CustomTextField(
                    icon: const FaIcon(Icons.abc),
                    label: 'Last Name',
                    required: true,
                    controller: _lastNameController,
                  ),
                ],
                CustomTextField(
                  icon: const Icon(Icons.password),
                  label: 'Password',
                  required: true,
                  controller: _passwordController,
                  obscureText: !_passwordShown,
                  toggleObscureText: () =>
                      setState(() => _passwordShown = !_passwordShown),
                  helperText: 'At least 8 characters',
                ),
                if (!_isLogin) ...[
                  CustomTextField(
                    icon: const Icon(Icons.password),
                    label: 'Repeat Password',
                    required: true,
                    controller: _repeatPasswordController,
                    obscureText: !_passwordShown,
                    toggleObscureText: () =>
                        setState(() => _passwordShown = !_passwordShown),
                  ),
                  if (_userType == UserType.doctor)
                    CustomTextField(
                      icon: const Icon(Icons.medical_information),
                      label: 'Medical ID',
                      required: true,
                      controller: _medicalIdController,
                      hint: 'e.g. 12345',
                    )
                  else if (_userType == UserType.patient)
                    CustomTextField(
                      icon: const Icon(Icons.calendar_month),
                      label: 'BirthDate',
                      required: true,
                      controller: _birthdateController,
                      hint: 'YYYY-mm-dd',
                    ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _isLogin
                          ? 'Don\'t have an account?'
                          : 'Already have an account?',
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin ? 'Register Here!' : 'Login Here!'),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                FilledButton(
                  onPressed: _isLogin ? _login : _register,
                  child: Text(_isLogin ? 'Login' : 'Register'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    final response = await _authService.login(
      ssid: _ssidController.text,
      password: _passwordController.text,
    );
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

  _register() {
    // todo
  }
}
