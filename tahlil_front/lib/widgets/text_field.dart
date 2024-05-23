import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  final Widget? icon;
  final String? label, hint, helperText;
  final bool required;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Function()? toggleObscureText;

  const CustomTextField({
    super.key,
    this.icon,
    this.label,
    this.hint,
    this.helperText,
    this.keyboardType,
    this.required = false,
    this.obscureText = false,
    this.toggleObscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                icon: icon,
                label: label == null
                    ? null
                    : Text('${label!}${required ? " *" : ""}'),
                hintText: hint,
                helperText: helperText,
              ),
            ),
          ),
          if (toggleObscureText != null)
            SizedBox.square(
              dimension: 50,
              child: Center(
                child: IconButton(
                  icon: FaIcon(
                    obscureText
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                  ),
                  onPressed: toggleObscureText!,
                ),
              ),
            )
        ],
      ),
    );
  }
}
