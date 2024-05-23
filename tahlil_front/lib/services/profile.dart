import 'dart:convert';

import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/patient.dart';
import 'package:tahlil_front/classes/referrer.dart';
import 'package:tahlil_front/classes/user.dart';
import 'package:tahlil_front/services/network.dart';

class ProfileService {
  static ProfileService? _instance;

  static ProfileService get instance {
    _instance ??= ProfileService();
    return _instance!;
  }

  final NetworkService _networkService = NetworkService.instance;

  User? _profile;

  Future<User?> get profile async {
    if (_profile == null) {
      final response = await _networkService.get('/profile');
      if (response.isOk) {
        final body = jsonDecode(response.bodyString!);
        switch (body['user_type']) {
          case 'patient':
            _profile = Patient.fromJson(body);
            break;
          case 'doctor':
            _profile = Doctor.fromJson(body);
            break;
          case 'referrer':
            _profile = Referrer.fromJson(body);
            break;
        }
      }
    }
    return _profile;
  }

  Future<User?> forceUpdateProfile() {
    _profile = null;
    return profile;
  }
}
