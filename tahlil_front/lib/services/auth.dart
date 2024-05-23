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
    final response = await _networkService.post(
      '/auth/login',
      {'ssid': ssid, 'password': password},
    );
    return Pair(response.statusCode == 200, response.body ?? '');
  }
}
