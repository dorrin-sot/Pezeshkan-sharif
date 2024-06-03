import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tahlil_front/classes/appointment.dart';
import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/imaging_center.dart';
import 'package:tahlil_front/enums/province.dart';
import 'package:tahlil_front/enums/user_type.dart';
import 'package:tahlil_front/services/appointment.dart';
import 'package:tahlil_front/services/profile.dart';
import 'package:tahlil_front/services/router.dart';
import 'package:tahlil_front/utils/pair.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final _appointmentService = AppointmentService.instance;
  final _profileService = ProfileService.instance;

  List<Appointment> filteredAppointments = [];

  bool onlyUpcoming = true;
  bool showDoctor = true;
  bool showImagingCenter = true;
  List<String> provinces = [], specialties = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 260,
            child: _SortFilterToolbarWidget(
              setFilters: ({
                bool onlyUpcoming = true,
                bool showDoctor = true,
                bool showImagingCenter = true,
                Pair<DateTime, DateTime>? dateRange,
                List<String>? provinces,
                List<String>? specialties,
              }) {
                this.onlyUpcoming = onlyUpcoming;
                this.showDoctor = showDoctor;
                this.showImagingCenter = showImagingCenter;
                this.provinces = provinces ?? [];
                this.specialties = specialties ?? [];

                setState(() {});
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 75, right: 25),
              child: FutureBuilder<List<Appointment>>(
                future: _appointmentService.getAppointments(),
                builder: (context, snapshot) {
                  filteredAppointments = (snapshot.data ?? []).where((a) {
                    if (showDoctor && a is ImagingCenterAppointment) {
                      return false;
                    }
                    if (showImagingCenter && a is DoctorAppointment) {
                      return false;
                    }
                    if (onlyUpcoming && a.time.isInPast) return false;
                    return true;
                  }).toList();

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
                  if (snapshot.data!.isEmpty) {
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

                  return GridView.builder(
                    itemCount: filteredAppointments.length,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 50),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500,
                      mainAxisExtent: 100,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (context, i) {
                      final bodyMedium = Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold);

                      final Appointment appointment = filteredAppointments[i];
                      return Material(
                        elevation: 2,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          onTap: () => RouterService.go(
                              '/appointment/${appointment.id}'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(FontAwesomeIcons.user),
                                const SizedBox(width: 10),
                                Text(
                                  (_profileService.profileCached!.isPatient
                                          ? appointment is DoctorAppointment
                                              ? appointment.doctorName
                                              : (appointment
                                                      as ImagingCenterAppointment)
                                                  .imaginCenterName
                                          : appointment.patientName)
                                      .capitalize!,
                                  style: bodyMedium,
                                ),
                                Expanded(child: Container()),
                                const FaIcon(FontAwesomeIcons.businessTime),
                                const SizedBox(width: 10),
                                Text(
                                  '${appointment.time}'.capitalize!,
                                  style: bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortFilterToolbarWidget extends StatefulWidget {
  final void Function({
    bool onlyUpcoming,
    bool showDoctor,
    bool showImagingCenter,
    Pair<DateTime, DateTime>? dateRange,
    List<String> provinces,
    List<String>? specialties,
  }) setFilters;

  const _SortFilterToolbarWidget({required this.setFilters});

  @override
  State<_SortFilterToolbarWidget> createState() =>
      _SortFilterToolbarWidgetState();
}

class _SortFilterToolbarWidgetState extends State<_SortFilterToolbarWidget> {
  bool onlyUpcoming = true;
  bool showDoctor = true;
  bool showImagingCenter = true;
  Pair<DateTime, DateTime>? dateRange;
  List<Province> provinces = Province.values;
  List<String> specialties = [];
  List<Doctor> doctors = [];
  List<ImagingCenter> imagingCenters = [];

  UserType get userType => ProfileService.instance.profileCached!.userType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 1)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (userType == UserType.patient) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Only Doctors?'),
                  Checkbox(
                    value: showDoctor,
                    onChanged: (new_) => setState(() => showDoctor = new_!),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Only Imaging Centers?'),
                  Checkbox(
                    value: showImagingCenter,
                    onChanged: (new_) =>
                        setState(() => showImagingCenter = new_!),
                  )
                ],
              ),
            ),
          ],
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Only Show Upcoming?'),
                Checkbox(
                  value: onlyUpcoming,
                  onChanged: (new_) => setState(() => onlyUpcoming = new_!),
                ),
              ],
            ),
          ),
          // const Divider(),
          // Padding( // todo
          //   padding: const EdgeInsets.symmetric(vertical: 7),
          //   child: ChoicesWidget<Province>(
          //     title: 'Province',
          //     availableValues: Province.values,
          //     labels: Province.values.asMap().map((_, v) => MapEntry(v, '$v')),
          //     selectedValues: provinces ?? [],
          //     onChange: (newLst) {
          //       provinces = newLst.cast<Province>();
          //       _submit();
          //     },
          //   ),
          // ),
          // todo add specialties ChoicesWidget
        ],
      ),
    );
  }

  void _submit() {
    widget.setFilters(
      onlyUpcoming: onlyUpcoming,
      showDoctor: showDoctor,
      showImagingCenter: showImagingCenter,
      dateRange: dateRange,
      provinces: provinces.map((e) => '$e').toList(),
      specialties: specialties,
    );
    setState(() {});
  }

  void _reset() {
    onlyUpcoming = true;
    showDoctor = true;
    showImagingCenter = true;
    dateRange = null;
    provinces = [];
    specialties = [];
    _submit();
  }
}
