import 'package:tahlil_front/classes/work_time.dart';
import 'package:tahlil_front/enums/weekday.dart';

class ImagingCenter {
  final int id;
  final String name;
  final String? phoneNumber, emailAddress, province, city, street;
  final List<WorkTime> workTimes;

  ImagingCenter({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.emailAddress,
    this.province,
    this.city,
    this.street,
    required this.workTimes,
  });

  ImagingCenter.fromJson(dynamic json)
      : this(
          id: json['id'],
          name: json['name'],
          phoneNumber: json['phone_number'],
          emailAddress: json['email_address'],
          province: json['province'],
          city: json['city'],
          street: json['street'],
          workTimes: (json['work_times'] as String?)
                  ?.split(', ')
                  .map(
                    (t) => WorkTime(
                      weekday: Weekday.find(t.split(' ')[0]),
                      startHour: int.parse(t.split(' ')[1].split('-')[0]),
                      endHour: int.parse(t.split(' ')[1].split('-')[1]),
                    ),
                  )
                  .toList() ??
              [],
        );
}
