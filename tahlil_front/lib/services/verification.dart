import 'dart:convert';

import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/patient.dart';
import 'package:tahlil_front/classes/user.dart';
import 'package:tahlil_front/services/network.dart';

class VerificationService {
  static VerificationService? _instance;

  static VerificationService get instance {
    _instance ??= VerificationService();
    return _instance!;
  }

  final NetworkService _networkService = NetworkService.instance;

  Future<List<User>> verifyList() async {
    final response = await _networkService.get('/referees');
    return (jsonDecode(response.bodyString!) as List)
        .map((json) => json['user_type'] == 'doctor'
            ? Doctor.fromJson(json)
            : Patient.fromJson(json))
        .toList();
  }

  Future<bool> decline(String ssid) async {
    final response = await _networkService.post('/referees/$ssid/decline', {});
    return response.statusCode == 200;
  }

  Future<bool> accept(String ssid) async {
    final response = await _networkService.post('/referees/$ssid/accept', {});
    return response.statusCode == 200;
  }
}
