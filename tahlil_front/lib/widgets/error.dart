import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  void Function() refresh;
  String msg;

  ErrorWidget({super.key, required this.msg, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/error.png', width: 500),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              msg,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: refresh,
            )
          ],
        )
      ],
    );
  }
}
