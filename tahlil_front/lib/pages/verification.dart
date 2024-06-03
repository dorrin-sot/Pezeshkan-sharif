import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/patient.dart';
import 'package:tahlil_front/classes/user.dart';
import 'package:tahlil_front/extensions/string_ext.dart';
import 'package:tahlil_front/services/verification.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  static final _verificationService = VerificationService.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _verificationService.verifyList(),
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
        return GridView.builder(
          itemCount: snapshot.data!.length,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            mainAxisExtent: 200,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemBuilder: (context, i) {
            final user = snapshot.data![i];
            final textTheme = Theme.of(context).textTheme;
            final labelSmall = textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white);
            final titleMedium =
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
            final bodyMedium =
                textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

            return Material(
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Badge(
                            label: Text(
                              user.isDoctor ? 'Doctor' : 'Patient',
                              style: labelSmall,
                            ),
                            offset: Offset(15, -4),
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              '${user.firstName} ${user.lastName}',
                              style: titleMedium,
                            ),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.cancel),
                              label: const Text('Decline'),
                              onPressed: user.isDeclined
                                  ? null
                                  : () => _verificationService
                                      .decline(user.ssid)
                                      .then((_) => setState(() {})),
                            ),
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Accept'),
                            onPressed: user.isVerified
                                ? null
                                : () => _verificationService
                                    .accept(user.ssid)
                                    .then((_) => setState(() {})),
                          ),
                        ],
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
                          if (user is Doctor)
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.medical_information),
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
                          if (user is Patient)
                            const Icon(Icons.calendar_month)
                          else
                            const FaIcon(FontAwesomeIcons.userDoctor),
                          const SizedBox(width: 10),
                          Text(
                            ((user is Patient)
                                    ? user.birthDate
                                    : (user as Doctor).specialty) ??
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
                          const Icon(Icons.pin_drop),
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
