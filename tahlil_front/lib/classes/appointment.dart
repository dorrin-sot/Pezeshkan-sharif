import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/imaging_center.dart';
import 'package:tahlil_front/classes/patient.dart';
import 'package:tahlil_front/classes/time.dart';

class Appointment {
  final int id;
  final Patient patient;
  final Time time;

  Appointment({
    required this.id,
    required String patientSsid,
    required String patientFirstName,
    required String patientLastName,
    String? patientProvince,
    String? patientCity,
    String? patientStreet,
    String? patientEmailAddress,
    String? patientPhoneNumber,
    String? patientBirthdate,
    String? patientPfp,
    required this.time,
  }) : patient = Patient(
          ssid: patientSsid,
          firstName: patientFirstName,
          lastName: patientLastName,
          province: patientProvince,
          city: patientCity,
          street: patientStreet,
          emailAddress: patientEmailAddress,
          phoneNumber: patientPhoneNumber,
          birthDate: patientBirthdate,
          pfp: patientPfp,
          password: '',
          isVerified: true,
          isDeclined: false,
        );
}

class DoctorAppointment extends Appointment {
  final Doctor doctor;

  DoctorAppointment({
    required super.id,
    required super.time,
    required super.patientSsid,
    required super.patientFirstName,
    required super.patientLastName,
    super.patientProvince,
    super.patientCity,
    super.patientStreet,
    super.patientEmailAddress,
    super.patientPhoneNumber,
    super.patientBirthdate,
    super.patientPfp,
    required String doctorSsid,
    required String doctorFirstName,
    required String doctorLastName,
    required String doctorMedicalId,
    String? doctorProvince,
    String? doctorCity,
    String? doctorStreet,
    String? doctorEmailAddress,
    String? doctorPhoneNumber,
    String? doctorPfp,
    String? doctorWorkTimes,
    String? doctorSpecialty,
  }) : doctor = Doctor(
          ssid: doctorSsid,
          firstName: doctorFirstName,
          lastName: doctorLastName,
          province: doctorProvince,
          city: doctorCity,
          street: doctorStreet,
          emailAddress: doctorEmailAddress,
          phoneNumber: doctorPhoneNumber,
          medicalId: doctorMedicalId,
          pfp: doctorPfp,
          specialty: doctorSpecialty,
          workTimes: doctorWorkTimes,
          password: '',
          isVerified: true,
          isDeclined: false,
        );

  DoctorAppointment.fromJson(dynamic json)
      : this(
          id: json['id'],
          patientSsid: json['patient'],
          patientFirstName: json['patient_first_name'],
          patientLastName: json['patient_last_name'],
          patientProvince: json['patient_province'],
          patientCity: json['patient_city'],
          patientStreet: json['patient_street'],
          patientEmailAddress: json['patient_email_address'],
          patientPhoneNumber: json['patient_phone_number'],
          patientBirthdate: json['patient_birth_date'],
          patientPfp: json['patient_pfp'],
          doctorProvince: json['doctor_province'],
          doctorSsid: json['doctor'],
          doctorFirstName: json['doctor_first_name'],
          doctorLastName: json['doctor_last_name'],
          doctorCity: json['doctor_city'],
          doctorStreet: json['doctor_street'],
          doctorEmailAddress: json['doctor_email_address'],
          doctorPhoneNumber: json['doctor_phone_number'],
          doctorWorkTimes: json['doctor_work_times'],
          doctorMedicalId: json['doctor_medical_id'],
          doctorSpecialty: json['doctor_specialty'],
          doctorPfp: json['doctor_pfp'],
          time: Time.fromJson(json),
        );
}

class ImagingCenterAppointment extends Appointment {
  final ImagingCenter imagingCenter;

  ImagingCenterAppointment({
    required super.id,
    required super.time,
    required super.patientSsid,
    required super.patientFirstName,
    required super.patientLastName,
    super.patientProvince,
    super.patientCity,
    super.patientStreet,
    super.patientEmailAddress,
    super.patientPhoneNumber,
    super.patientBirthdate,
    super.patientPfp,
    required int imagingCenterId,
    required String imagingCenterName,
    String? imagingCenterProvince,
    String? imagingCenterCity,
    String? imagingCenterStreet,
    String? imagingCenterEmailAddress,
    String? imagingCenterPhoneNumber,
    String? imagingCenterWorkTimes,
  }) : imagingCenter = ImagingCenter(
          id: imagingCenterId,
          name: imagingCenterName,
          province: imagingCenterProvince,
          city: imagingCenterCity,
          street: imagingCenterStreet,
          emailAddress: imagingCenterEmailAddress,
          phoneNumber: imagingCenterPhoneNumber,
          workTimes: imagingCenterWorkTimes,
          password: '',
          isVerified: true,
          isDeclined: false,
        );

  ImagingCenterAppointment.fromJson(dynamic json)
      : this(
          id: json['id'],
          patientSsid: json['patient'],
          patientFirstName: json['patient_first_name'],
          patientLastName: json['patient_last_name'],
          patientProvince: json['patient_province'],
          patientCity: json['patient_city'],
          patientStreet: json['patient_street'],
          patientEmailAddress: json['patient_email_address'],
          patientPhoneNumber: json['patient_phone_number'],
          patientBirthdate: json['patient_birth_date'],
          patientPfp: json['patient_pfp'],
          imagingCenterId: json['imaging_center'],
          imagingCenterName: json['imaging_center_name'],
          imagingCenterProvince: json['imaging_center_province'],
          imagingCenterCity: json['imaging_center_city'],
          imagingCenterStreet: json['imaging_center_street'],
          imagingCenterEmailAddress: json['imaging_center_email_address'],
          imagingCenterPhoneNumber: json['imaging_center_phone_number'],
          imagingCenterWorkTimes: json['imaging_center_work_times'],
          time: Time.fromJson(json),
        );
}
