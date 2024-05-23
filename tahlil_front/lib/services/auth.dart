import 'package:tahlil_front/services/network.dart';
import 'package:tahlil_front/utils/pair.dart';

class AuthService {
  static AuthService? _instance;

  static AuthService get instance {
    _instance ??= AuthService();
    return _instance!;
  }

  NetworkService _networkService = NetworkService.instance;

  bool is_logged_in() {
    return true; // todo
  }

  Future<Pair<bool, String>> login({
    required String ssid,
    required String password,
  }) async {
    final response = await _networkService.post(
      '/auth/login',
      {'ssid': ssid, 'password': password},
    );
    return Pair(response.statusCode == 200, response.body);
  }
}
