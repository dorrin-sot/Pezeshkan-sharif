import 'package:tahlil_front/enums/user_type.dart';
import 'package:tahlil_front/services/network.dart';
import 'package:tahlil_front/utils/pair.dart';

class AuthService {
  static AuthService? _instance;

  static AuthService get instance {
    _instance ??= AuthService();
    return _instance!;
  }

  final NetworkService _networkService = NetworkService.instance;

  Future<bool> isLoggedIn() async {
    final response = await _networkService.get('/auth/is_logged_in');
    return response.statusCode == 200;
  }

  Future<Pair<bool, String>> login({
    required String ssid,
    required String password,
  }) async {
    if (ssid.isEmpty || password.isEmpty) {
      return Pair(false, 'All fields are required!');
    }

    final response = await _networkService.post(
      '/auth/login',
      {'ssid': ssid, 'password': password},
    );
    return Pair(response.statusCode == 200, response.body ?? '');
  }

  Future<Pair<bool, String>> register({
    required String ssid,
    required String firstName,
    required String lastName,
    required String password,
    required String repeatPassword,
    required UserType userType,
    String medicalId = '',
    String birthDate = '',
  }) async {
    if (ssid.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty ||
        repeatPassword.isEmpty ||
        (userType == UserType.doctor && medicalId.isEmpty) ||
        (userType == UserType.patient && birthDate.isEmpty)) {
      return Pair(false, 'All fields are required!');
    }
    if (password.length < 8) {
      return Pair(false, 'Password must be at least 8 characters!');
    }
    if (password != repeatPassword) {
      return Pair(false, 'Password and Repeat Password must match!');
    }
    final response = await _networkService.post(
      '/auth/login',
      {'ssid': ssid, 'password': password},
    );
    return Pair(response.statusCode == 200, response.body ?? '');
  }

  Future<Pair<bool, String>> logout() async {
    final response = await _networkService.delete('/auth/logout');
    return Pair(response.statusCode == 204, response.body ?? '');
  }
}
