import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tahlil_front/classes/doctor.dart';
import 'package:tahlil_front/classes/patient.dart';
import 'package:tahlil_front/classes/user.dart';
import 'package:tahlil_front/enums/user_type.dart';
import 'package:tahlil_front/extensions/string_ext.dart';
import 'package:tahlil_front/main.dart';
import 'package:tahlil_front/services/auth.dart';
import 'package:tahlil_front/services/profile.dart';
import 'package:tahlil_front/utils/triple.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService.instance;
  final _profileService = ProfileService.instance;

  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _profileService.profile,
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
        final profile = snapshot.data!;
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 100),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 2),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: isEditMode ? _EditBody(profile) : _ViewBody(profile),
                  ),
                ),
                const VerticalDivider(),
                Expanded(child: Container()),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: isEditMode
                          ? [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: FilledButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text('Save Changes'),
                                  onPressed: _editProfile,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Discard Changes'),
                                  onPressed: () =>
                                      setState(() => isEditMode = false),
                                ),
                              ),
                            ]
                          : [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: FilledButton.icon(
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit Profile'),
                                  onPressed: () =>
                                      setState(() => isEditMode = true),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: OutlinedButton.icon(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.rightFromBracket),
                                  label: const Text('Logout'),
                                  onPressed: _logout,
                                ),
                              ),
                            ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _editProfile() {
    // todo
  }

  Future<void> _logout() async {
    if ((await _authService.logout()).first) {
      GoRouter.of(shellNavigatorKey.currentContext!).go('/');
    }
  }
}

class _ViewBody extends StatefulWidget {
  final User user;

  const _ViewBody(this.user);

  @override
  State<_ViewBody> createState() => _ViewBodyState();
}

class _ViewBodyState extends State<_ViewBody> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final theme = Theme.of(context);

    // Add Identifying information (SSID, First Name, Last Name, Medical ID, Referrer ID)
    // Add Contact Information (Phone number, Email Address)
    // Add Login Information (Username, password)
    // Add Location Information (Province, City, Street)
    // Add Work Information (Specialty, work days and hours, "can the doctor do surgery?")
    // Add Row Access (Security: Only Doctor has read and write access)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Triple('Hello, ', null, '${user.firstName} ${user.lastName}'),
        Triple(
          'You are a ',
          const Icon(Icons.person),
          user.isDoctor
              ? UserType.doctor
              : user.isPatient
                  ? UserType.patient
                  : UserType.referrer,
        ),
        if (user is Doctor)
          Triple(
              'Your Medical ID is ', const Icon(Icons.numbers), user.medicalId)
        else if (user is Patient)
          Triple('You were born on ', const Icon(Icons.calendar_month),
              user.birthDate),
        Triple('You were verified by ', const Icon(Icons.person),
            user.referrerName ?? '-'),
        Triple('Your Phone number is ', const Icon(Icons.phone),
            user.phoneNumber ?? '-'),
        Triple('Your Email Address is ', const Icon(Icons.email),
            user.emailAddress ?? '-'),
        if (user is Doctor)
          Triple('You are a ', const FaIcon(FontAwesomeIcons.userDoctor),
              user.specialty ?? '-'),
        Triple(
            'Your Address is ',
            const Icon(Icons.pin_drop),
            // ignore: prefer_interpolation_to_compose_strings
            (user.province + ', ' + user.city + ', ' + user.street) ?? '-'),
      ].map((tup) {
        final label = tup.first;
        final icon = tup.second;
        final value = tup.third;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: icon ?? Container(),
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: label, style: theme.textTheme.bodyMedium),
                  TextSpan(
                    text: '$value',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ]),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _EditBody extends StatefulWidget {
  final User user;

  const _EditBody(this.user);

  @override
  State<_EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<_EditBody> {
  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
