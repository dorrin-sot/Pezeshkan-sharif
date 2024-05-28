import 'dart:convert';

import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/services/network.dart';

class AppointmentService {
  static AppointmentService? _instance;

  static AppointmentService get instance {
    _instance ??= AppointmentService();
    return _instance!;
  }

  final NetworkService _networkService = NetworkService.instance;

  Future<List<Doctor>> allDoctors({String? search}) async {
    final response = await _networkService
        .get('/doctors', query: {if (search != null) 'search': search});

    return (jsonDecode(response.bodyString!) as List)
        .map((json) => Doctor.fromJson(json))
        .toList();
  }

  Future<List> allImagingCenters({String? search}) {
    // todo
    return Future.value([]);
  }
}
