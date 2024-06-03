import 'package:flutter/material.dart';

class CreateAppointmentPage extends StatefulWidget {
  final String? doctorSsid, imagingCenterId;

  const CreateAppointmentPage({
    super.key,
    this.doctorSsid,
    this.imagingCenterId,
  }) : assert((doctorSsid ?? imagingCenterId) != null);

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
