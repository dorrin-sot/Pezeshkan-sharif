import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tahlil_front/classes/appointment.dart';
import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/imaging_center.dart';
import 'package:tahlil_front/classes/patient.dart';
import 'package:tahlil_front/classes/user.dart';
import 'package:tahlil_front/enums/toast_type.dart';
import 'package:tahlil_front/extensions/string_ext.dart';
import 'package:tahlil_front/main.dart';
import 'package:tahlil_front/services/appointment.dart';
import 'package:tahlil_front/services/profile.dart';
import 'package:tahlil_front/utils/pair.dart';
import 'package:tahlil_front/widgets/profile_picture.dart';
import 'package:tahlil_front/widgets/toast.dart';

class AppointmentPage extends StatefulWidget {
  final int id;

  const AppointmentPage(this.id, {super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _appointmentService = AppointmentService.instance;
  final _profileService = ProfileService.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Appointment?>(
      future: _appointmentService.getAppointment(widget.id),
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
        final appointment = snapshot.data!;

        return FutureBuilder<User?>(
            future: _profileService.profile,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final profile = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 30,
                ),
                child: Row(
                  children: [
                    if (profile.isPatient)
                      if (appointment is DoctorAppointment)
                        _GeneralInfoWidget(profile, appointment, doctor: true)
                      else
                        _GeneralInfoWidget(
                          profile,
                          appointment,
                          imagingCenter: true,
                        )
                    else
                      _GeneralInfoWidget(profile, appointment, patient: true),
                    const SizedBox(width: 20),
                    if (profile.isPatient)
                      if (appointment is DoctorAppointment)
                        _DetailedInfoWidget(profile, appointment, doctor: true)
                      else
                        _DetailedInfoWidget(
                          profile,
                          appointment,
                          imagingCenter: true,
                        )
                    else
                      _DetailedInfoWidget(profile, appointment, patient: true)
                  ],
                ),
              );
            });
      },
    );
  }

  Widget _GeneralInfoWidget(
    User profile,
    Appointment appointment, {
    bool imagingCenter = false,
    bool doctor = false,
    bool patient = false,
  }) {
    User? user;
    if (patient) {
      user = appointment.patient;
    } else if (doctor) {
      user = (appointment as DoctorAppointment).doctor;
    } else if (imagingCenter) {
      user = (appointment as ImagingCenterAppointment).imagingCenter;
    }

    final theme = Theme.of(context).textTheme;
    final titleLarge = theme.titleLarge?.copyWith(fontWeight: FontWeight.w900);
    final bodyLarge = theme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);

    return SplitWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (user is! ImagingCenter)
            Padding(
              padding: const EdgeInsets.only(
                left: 50,
                right: 50,
                top: 50,
                bottom: 30,
              ),
              child: ProfilePictureWidget(user!),
            ),
          Text(
            (user!.isImagingCenter
                    ? (user as ImagingCenter).name
                    : user.fullName)
                .capitalize!,
            textAlign: TextAlign.center,
            style: titleLarge,
          ),
          ...[
            Pair(const Icon(Icons.person), user.userType),
            if (user is Doctor)
              Pair(const Icon(Icons.medical_information), user.medicalId)
            else if (user is Patient)
              Pair(const Icon(Icons.calendar_month), user.birthDate ?? '-'),
            Pair(const Icon(Icons.phone), user.phoneNumber ?? '-'),
            Pair(const Icon(Icons.email), user.emailAddress ?? '-'),
            if (user is Doctor)
              Pair(
                const FaIcon(FontAwesomeIcons.userDoctor),
                user.specialty ?? '-',
              ),
            Pair(
                const Icon(Icons.pin_drop),
                // ignore: prefer_interpolation_to_compose_strings
                (user.province + ', ' + user.city + ', ' + user.street) ?? '-'),
          ].map((p) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: p.first,
                  ),
                  Text('${p.second}', style: bodyLarge)
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _DetailedInfoWidget(
    User profile,
    Appointment appointment, {
    bool imagingCenter = false,
    bool doctor = false,
    bool patient = false,
  }) {
    final theme = Theme.of(context).textTheme;
    final titleLarge = theme.titleLarge?.copyWith(fontWeight: FontWeight.w900);
    final bodyLarge = theme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);
    return SplitWidget(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${appointment.time}'.capitalize!, style: bodyLarge),
          if (patient) ...[
            // todo show patient history
          ] else ...[
            // todo show doctor or imaging center statistics
          ],
          Expanded(child: Container()),
          if (profile.isImagingCenter)
            TextButton.icon(
              icon: Icon(Icons.upload),
              label: Text('Upload Images'),
              onPressed: () => _uploadImages(appointment),
            )
        ],
      ),
    );
  }

  Widget SplitWidget({int flex = 1, Widget? child}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 2),
          ],
        ),
        child: child,
      ),
    );
  }

  Future<void> _uploadImages(Appointment appointment) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);

    if ((result?.files.length ?? 0) > 0) {
      final response = await _appointmentService.uploadImages(
        appointment: appointment.id,
        files: result!.files,
      );
      if (response.first) setState(() {});

      final toast = FToast();
      toast.init(rootNavigatorKey.currentContext!);
      toast.showToast(
        child: CustomToast(
          text: response.second,
          toastType: response.first ? ToastType.success : ToastType.error,
        ),
        gravity: ToastGravity.BOTTOM_LEFT,
      );
    }
  }
}
