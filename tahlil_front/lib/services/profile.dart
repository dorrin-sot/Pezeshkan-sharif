import 'dart:convert';

import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/patient.dart';
import 'package:tahlil_front/classes/referrer.dart';
import 'package:tahlil_front/classes/user.dart';
import 'package:tahlil_front/enums/weekday.dart';
import 'package:tahlil_front/services/network.dart';

class ProfileService {
  static ProfileService? _instance;

  static ProfileService get instance {
    _instance ??= ProfileService();
    return _instance!;
  }

  final NetworkService _networkService = NetworkService.instance;

  User? profileCached;

  Future<User?> get profile async {
    if (profileCached == null) {
      final response = await _networkService.get('/profile');
      if (response.isOk) {
        final body = jsonDecode(response.bodyString!);
        switch (body['user_type']) {
          case 'patient':
            profileCached = Patient.fromJson(body);
            break;
          case 'doctor':
            profileCached = Doctor.fromJson(body);
            break;
          case 'referrer':
            profileCached = Referrer.fromJson(body);
            break;
        }
      }
    }
    return profileCached;
  }

  Future<User?> forceUpdateProfile() {
    profileCached = null;
    return profile;
  }

  bool editWorkTimes(Map<Weekday, String> workTimes) {
    // todo
    return true;
  }
}
