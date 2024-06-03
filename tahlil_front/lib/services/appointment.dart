import 'dart:convert';

import 'package:tahlil_front/classes/appointment.dart';
import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/imaging_center.dart';
import 'package:tahlil_front/services/network.dart';
import 'package:tahlil_front/utils/pair.dart';

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
        .map(Doctor.fromJson)
        .toList();
  }

  Future<List<ImagingCenter>> allImagingCenters({String? search}) async {
    final response = await _networkService
        .get('/imaging-centers', query: {if (search != null) 'search': search});

    return (jsonDecode(response.bodyString!) as List)
        .map(ImagingCenter.fromJson)
        .toList();
  }

  Future<List<Appointment>> getAppointments() async {
    final response = await _networkService.get('/appointments');

    return (jsonDecode(response.bodyString!) as List).map((json) {
      if (json['doctor'] != null) {
        return DoctorAppointment.fromJson(json);
      } else {
        return ImagingCenterAppointment.fromJson(json);
      }
    }).toList();
  }

  Future<Pair<bool, String>> createAppointment(
    DateTime time, {
    String? doctor,
    String? imagingCenter,
  }) async {
    final response = await _networkService.post('/appointment', {
      if (doctor != null) 'doctor': doctor,
      if (imagingCenter != null) 'imaging_center': imagingCenter,
      'year': time.year,
      'month': time.month,
      'day': time.day,
      'hour': time.hour,
    });
    return Pair(response.isOk, response.bodyString ?? '-');
  }
}
