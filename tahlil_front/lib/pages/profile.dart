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
import 'package:tahlil_front/widgets/text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService.instance;
  final _profileService = ProfileService.instance;

  bool isEditMode = false;

  final TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      phoneNumberController = TextEditingController(),
      emailAddressController = TextEditingController(),
      provinceController = TextEditingController(),
      cityController = TextEditingController(),
      streetController = TextEditingController(),
      specialtyController = TextEditingController(),
      birthdateController = TextEditingController();

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
        firstNameController.text = profile.firstName;
        lastNameController.text = profile.lastName;
        phoneNumberController.text = profile.phoneNumber ?? '';
        emailAddressController.text = profile.emailAddress ?? '';
        provinceController.text = profile.province ?? '';
        cityController.text = profile.city ?? '';
        streetController.text = profile.street ?? '';
        if (profile is Doctor) {
          specialtyController.text = profile.specialty ?? '';
        } else if (profile is Patient) {
          birthdateController.text = profile.birthDate ?? '';
        }

        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 2),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 40, right: 20),
                  child: isEditMode
                      ? SizedBox(
                          width: 400,
                          child: _EditBody(
                            profile,
                            firstNameController: firstNameController,
                            lastNameController: lastNameController,
                            phoneNumberController: phoneNumberController,
                            emailAddressController: emailAddressController,
                            provinceController: provinceController,
                            cityController: cityController,
                            streetController: streetController,
                            specialtyController: specialtyController,
                            birthdateController: birthdateController,
                          ),
                        )
                      : SizedBox(width: 200, child: _ViewBody(profile)),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, right: 40, left: 20),
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: isEditMode
                          ? [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: FilledButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text('Save Changes'),
                                  onPressed: _editProfile,
                                  // onPressed: _editProfile,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Triple('Hello ', null, '${user.firstName} ${user.lastName}'),
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
  final TextEditingController firstNameController,
      lastNameController,
      phoneNumberController,
      emailAddressController,
      provinceController,
      cityController,
      streetController;
  final TextEditingController? specialtyController, birthdateController;

  const _EditBody(
    this.user, {
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNumberController,
    required this.emailAddressController,
    required this.provinceController,
    required this.cityController,
    required this.streetController,
    this.specialtyController,
    this.birthdateController,
  });

  @override
  State<_EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<_EditBody> {
  late final TextEditingController _firstNameController,
      _lastNameController,
      _phoneNumberController,
      _emailAddressController,
      _provinceController,
      _cityController,
      _streetController;
  late final TextEditingController? _specialtyController, _birthdateController;

  @override
  void initState() {
    super.initState();
    _firstNameController = widget.firstNameController;
    _lastNameController = widget.lastNameController;
    _phoneNumberController = widget.phoneNumberController;
    _emailAddressController = widget.emailAddressController;
    _provinceController = widget.provinceController;
    _cityController = widget.cityController;
    _streetController = widget.streetController;
    _specialtyController = widget.specialtyController;
    _birthdateController = widget.birthdateController;
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextField(
          icon: const Icon(Icons.abc),
          label: 'First Name',
          required: true,
          controller: _firstNameController,
        ),
        CustomTextField(
          icon: const Icon(Icons.abc),
          label: 'Last Name',
          required: true,
          controller: _lastNameController,
        ),
        CustomTextField(
          icon: const Icon(Icons.phone),
          label: 'Phone Number',
          required: true,
          controller: _phoneNumberController,
        ),
        CustomTextField(
          icon: const Icon(Icons.email),
          label: 'Email Address',
          required: true,
          hint: 'e.g. abc@email.com',
          controller: _emailAddressController,
        ),
        if (user.isDoctor)
          CustomTextField(
            icon: const FaIcon(FontAwesomeIcons.userDoctor),
            label: 'Specialty',
            required: true,
            controller: _specialtyController!,
          )
        else if (user.isPatient)
          CustomTextField(
            icon: const Icon(Icons.calendar_month),
            label: 'BirthDate',
            required: true,
            controller: _birthdateController!,
            hint: 'YYYY-mm-dd',
          ),
        CustomTextField(
          icon: const Icon(Icons.location_city),
          label: 'Province',
          required: true,
          controller: _provinceController,
        ),
        CustomTextField(
          icon: const Icon(Icons.location_city),
          label: 'City',
          required: true,
          controller: _cityController,
        ),
        CustomTextField(
          icon: const Icon(Icons.location_city),
          label: 'Street',
          required: true,
          controller: _streetController,
        ),
      ],
    );
  }
}
