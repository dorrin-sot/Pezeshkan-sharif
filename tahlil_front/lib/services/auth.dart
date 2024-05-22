import 'package:tahlil_front/services/network.dart';

class AuthService {
  static AuthService? _instance;

  static AuthService get instance {
    _instance ??= AuthService();
    return _instance!;
  }

  NetworkService networkService = NetworkService.instance;

  bool is_logged_in() {
    return true; // todo
  }
}
