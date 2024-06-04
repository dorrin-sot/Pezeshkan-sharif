import 'package:tahlil_front/classes/time.dart';

class Appointment {
  final int id;
  final String patientSsid, patientName;
  final Time time;

  Appointment({
    required this.id,
    required this.patientSsid,
    required this.patientName,
    required this.time,
  });

  Appointment.fromJson(dynamic json)
      : this(
          id: json['id'],
          patientSsid: json['patient'],
          patientName: json['patient_full_name'],
          time: Time.fromJson(json),
        );
}

class DoctorAppointment extends Appointment {
  final String doctorSsid, doctorName;

  DoctorAppointment({
    required super.id,
    required super.patientSsid,
    required super.patientName,
    required super.time,
    required this.doctorSsid,
    required this.doctorName,
  });

  DoctorAppointment.fromJson(dynamic json)
      : this(
          id: json['id'],
          patientSsid: json['patient'],
          patientName: json['patient_full_name'],
          doctorSsid: json['doctor'],
          doctorName: json['doctor_full_name'],
          time: Time.fromJson(json),
        );
}

class ImagingCenterAppointment extends Appointment {
  final int imagingCenterId;
  final String imagingCenterName;

  ImagingCenterAppointment({
    required super.id,
    required super.patientSsid,
    required super.patientName,
    required super.time,
    required this.imagingCenterId,
    required this.imagingCenterName,
  });

  ImagingCenterAppointment.fromJson(dynamic json)
      : this(
          id: json['id'],
          patientSsid: json['patient'],
          patientName: json['patient_full_name'],
          imagingCenterId: json['imaging_center'],
          imagingCenterName: json['imaging_center_name'],
          time: Time.fromJson(json),
        );
}
