// lib/features/auth/presentation/pages/widgets/password_field.dart
import 'package:flutter/material.dart';
import '../../../../../../core/utils/input_validator.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;

  const PasswordField({
    super.key,
    required this.controller,
    this.obscureText = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: InputValidator.validatePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
