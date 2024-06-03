import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tahlil_front/classes/appointment.dart' as ap;

class AppointmentDataSource extends CalendarDataSource<ap.Appointment> {
  static final colors = Colors.primaries.map((c) => c.shade700).toList();

  List<ap.Appointment> _appointments;

  @override
  List<ap.Appointment> get appointments => _appointments;

  AppointmentDataSource(List<ap.Appointment> appointments)
      : _appointments = appointments;

  @override
  DateTime getStartTime(int index) => appointments[index].time.dateTime;

  @override
  DateTime getEndTime(int index) =>
      appointments[index].time.dateTime.add(const Duration(hours: 1));

  @override
  String getSubject(int index) => '';

  @override
  bool isAllDay(int index) => false;

  @override
  Color getColor(int index) => Colors.black12;
}
