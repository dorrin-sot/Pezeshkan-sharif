import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tahlil_front/classes/appointment.dart' as ap;
import 'package:tahlil_front/services/appointment.dart';
import 'package:tahlil_front/utils/appointment_data_source.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final _appointmentService = AppointmentService.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: FutureBuilder<List<ap.Appointment>>(
        future: _appointmentService.getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/error.png', width: 600),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Encountered an error loading your profile!',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => Future(() => setState(() {})),
                    )
                  ],
                )
              ],
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final appointments = snapshot.data ?? [];

          if (appointments.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/empty.png', width: 600),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No User has you as their referrer!',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => Future(() => setState(() {})),
                    )
                  ],
                )
              ],
            );
          }

          return SfCalendar(
            view: CalendarView.schedule,
            firstDayOfWeek: 6,
            showDatePickerButton: true,
            showTodayButton: true,
            showWeekNumber: true,
            showNavigationArrow: true,
            allowViewNavigation: true,
            allowedViews: const [
              CalendarView.schedule,
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
            ],
            minDate: DateTime.now(),
            maxDate: appointments
                .map((a) => a.time.dateTime)
                .reduce((val, elem) => val.isAfter(elem) ? val : elem),
            dataSource: AppointmentDataSource(
              appointments,
              showAppointmentInfo: true,
            ),
            timeSlotViewSettings: const TimeSlotViewSettings(
              nonWorkingDays: [],
              minimumAppointmentDuration: Duration(hours: 1),
              dateFormat: 'dd',
              dayFormat: 'EEE',
              timeFormat: 'HH',
            ),
          );
        },
      ),
    );
  }
}
