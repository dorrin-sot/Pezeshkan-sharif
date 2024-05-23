class User {
  final String ssid;
  final String firstName;
  final String lastName;
  final String password;
  final String? referrerSsid;
  final String? phoneNumber;
  final String? emailAddress;
  final String? province;
  final String? city;
  final String? street;
  final bool isVerified, isDeclined;

  User({
    required this.ssid,
    required this.firstName,
    required this.lastName,
    required this.password,
    this.referrerSsid,
    this.phoneNumber,
    this.emailAddress,
    this.province,
    this.city,
    this.street,
    required this.isVerified,
    required this.isDeclined,
  });
}
