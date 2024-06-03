import 'package:shamsi_date/shamsi_date.dart';
import 'package:tahlil_front/enums/weekday.dart';

class Time {
  final int year, month, day, hour;
  final Weekday weekday;

  Time({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.weekday,
  });

  Time.fromJson(dynamic json)
      : this(
          year: int.parse(json['year']),
          month: int.parse(json['month']),
          day: int.parse(json['day']),
          hour: int.parse(json['hour']),
          weekday: Weekday.find(json['weekday']),
        );

  bool get isInPast =>
      !DateTime.now().isBefore(Jalali(year, month, day, hour).toDateTime());

  @override
  String toString() => '$weekday $year-$month-$day @$hour:00';
}
