// lib/core/presentation/widgets/dialogs/confirmation_dialog.dart

import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color? confirmColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => ConfirmationDialog(
            title: title,
            message: message,
            onConfirm: onConfirm,
            confirmText: confirmText,
            cancelText: cancelText,
            confirmColor: confirmColor,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? Theme.of(context).primaryColor,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
