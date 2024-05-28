import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/extensions/string_ext.dart';
import 'package:tahlil_front/services/appointment.dart';
import 'package:tahlil_front/services/router.dart';
import 'package:tahlil_front/widgets/text_field.dart';

class ExplorePage extends StatefulWidget {
  final bool doctors;

  const ExplorePage({super.key, required this.doctors});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final AppointmentService _appointmentService = AppointmentService.instance;

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: widget.doctors
          ? _appointmentService.allDoctors(
              search: _searchController.text.nullIfEmpty)
          : _appointmentService.allImagingCenters(
              search: _searchController.text.nullIfEmpty),
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, bottom: 25),
              child: CustomTextField(
                controller: _searchController,
                icon: const Icon(Icons.search),
                hint: 'Search for '
                    '${widget.doctors ? 'Doctors' : 'Imaging Centers'}...',
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: snapshot.data!.length,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 500,
                  mainAxisExtent: 225,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemBuilder: (context, i) {
                  final textTheme = Theme.of(context).textTheme;
                  final titleMedium = textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold);
                  final bodyMedium = textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold);

                  if (widget.doctors) {
                    final Doctor user = snapshot.data![i];
                    return Material(
                      elevation: 2,
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () => RouterService.go(
                            '/create-appointment/${user.ssid}'),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${user.firstName} ${user.lastName}',
                                style: titleMedium,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const FaIcon(FontAwesomeIcons.idCard),
                                        const SizedBox(width: 10),
                                        Text(user.ssid, style: bodyMedium),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const FaIcon(FontAwesomeIcons.idBadge),
                                        const SizedBox(width: 10),
                                        Text(user.medicalId, style: bodyMedium),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.phone),
                                        const SizedBox(width: 10),
                                        Text(user.phoneNumber ?? '-',
                                            style: bodyMedium),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.email),
                                        const SizedBox(width: 10),
                                        Text(user.emailAddress ?? '-',
                                            style: bodyMedium),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.userDoctor),
                                  const SizedBox(width: 10),
                                  Text(
                                    user.specialty ?? '-',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_city),
                                  const SizedBox(width: 10),
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    (user.province +
                                            ', ' +
                                            user.city +
                                            ', ' +
                                            user.street) ??
                                        '-',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.work),
                                  const SizedBox(width: 10),
                                  Text(
                                    user.workTimes
                                            .map((wt) => '$wt')
                                            .join(', ')
                                            .nullIfEmpty ??
                                        '-',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(); // todo
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
