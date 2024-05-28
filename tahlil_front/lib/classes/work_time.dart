import 'package:tahlil_front/enums/weekday.dart';

class WorkTime {
  final Weekday weekday;
  final int startHour, endHour;

  WorkTime({
    required this.weekday,
    required this.startHour,
    required this.endHour,
  });

  @override
  String toString() {
    return '${weekday.toString().substring(0, 3)} $startHour-$endHour';
  }
}
