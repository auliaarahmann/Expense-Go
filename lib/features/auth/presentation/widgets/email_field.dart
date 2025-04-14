// lib/features/auth/presentation/pages/widgets/email_field.dart
import 'package:flutter/material.dart';
import '../../../../../../core/utils/input_validator.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      validator: InputValidator.validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
