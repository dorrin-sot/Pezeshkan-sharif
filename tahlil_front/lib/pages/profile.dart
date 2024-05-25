import 'package:flutter/material.dart';
import 'package:tahlil_front/classes/user.dart';
import 'package:tahlil_front/services/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            child: isEditMode ? _EditBody(profile) : _ViewBody(profile),
          ),
        );
      },
    );
  }
}

class _ViewBody extends StatefulWidget {
  final User user;

  const _ViewBody(this.user);

  @override
  State<_ViewBody> createState() => _ViewBodyState();
}

class _ViewBodyState extends State<_ViewBody> {
  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
