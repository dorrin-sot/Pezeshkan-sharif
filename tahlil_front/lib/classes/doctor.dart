import 'package:tahlil_front/classes/user.dart';

class Doctor extends User {
  final String medicalId;
  final String? specialty;
  final bool canSurgery;

  Doctor({
    required super.ssid,
    required super.firstName,
    required super.lastName,
    required super.password,
    super.referrerSsid,
    super.phoneNumber,
    super.emailAddress,
    super.province,
    super.city,
    super.street,
    required super.isVerified,
    required super.isDeclined,
    required this.medicalId,
    required this.specialty,
    required this.canSurgery,
  });

  Doctor.fromJson(dynamic json) : this(
      ssid: json['ssid'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      password: json['password'],
      referrerSsid: json['referrer'],
      phoneNumber: json['phone_number'],
      emailAddress: json['email_address'],
      province: json['province'],
      city: json['city'],
      street: json['street'],
      isVerified: json['is_verified'],
      isDeclined: json['is_declined'],
      medicalId: json['medical_id'],
      specialty: json['specialty'],
      canSurgery: json['can_surgery'],
  );
}
