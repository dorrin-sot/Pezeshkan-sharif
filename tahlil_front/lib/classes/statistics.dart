// ignore_for_file: use_super_parameters

import 'package:tahlil_front/utils/pair.dart';

class Statistics {}

class DoctorImagingCenterStatistics extends Statistics {
  final Map<int, int> groupedRating;
  final double avgRating;
  final Map<Pair<int, int>, int> groupedAppointmentsByMonth;

  DoctorImagingCenterStatistics({
    required this.groupedRating,
    required this.avgRating,
    required this.groupedAppointmentsByMonth,
  });

  DoctorImagingCenterStatistics.fromJson(json)
      : this(
          groupedRating: {
            ...Map.fromEntries(List.generate(5, (i) => MapEntry(i, 0))),
            ...(json['grouped_ratings'] as List)
                .asMap()
                .map((_, e) => MapEntry(e['rating']!, int.parse(e['count']))),
          },
          avgRating: double.parse(json['avg_rating']),
          groupedAppointmentsByMonth:
              (json['grouped_appointments_by_month'] as List).asMap().map(
                    (_, e) => MapEntry(
                      Pair(int.parse(e['month']!), int.parse(e['year']!)),
                      int.parse(e['count']!),
                    ),
                  ),
        );
}

class ReferrerStatistics extends Statistics {
  final Map<String, int> refereePercentages;

  ReferrerStatistics({required this.refereePercentages});

  ReferrerStatistics.fromJson(json)
      : this(
          refereePercentages: {
            'verified': 0,
            'declined': 0,
            'waiting': 0,
            ...(json['referee_percentages'] as List)
                .asMap()
                .map((_, e) => MapEntry(e['status']!, int.parse(e['count']!))),
          },
        );
}

class ImagingCenterStatistics extends DoctorImagingCenterStatistics {
  ImagingCenterStatistics({
    required super.groupedRating,
    required super.avgRating,
    required super.groupedAppointmentsByMonth,
  });

  ImagingCenterStatistics.fromJson(json) : super.fromJson(json);
}

class DoctorStatistics extends DoctorImagingCenterStatistics {
  final Map<int, int> groupedPatientsByAge;
  final Map<int, int> groupedRepeatCount;

  DoctorStatistics({
    required super.groupedRating,
    required super.avgRating,
    required super.groupedAppointmentsByMonth,
    required this.groupedPatientsByAge,
    required this.groupedRepeatCount,
  });

  DoctorStatistics.fromJson(json)
      : groupedPatientsByAge =
            (json['grouped_patients_by_age'] as List).asMap().map(
                  (_, e) =>
                      MapEntry(int.parse(e['age']!), int.parse(e['count']!)),
                ),
        groupedRepeatCount = (json['grouped_repeat_count'] as List).asMap().map(
              (_, e) => MapEntry(
                int.parse(e['repeat_count']!),
                int.parse(e['count']!),
              ),
            ),
        super.fromJson(json);
}
