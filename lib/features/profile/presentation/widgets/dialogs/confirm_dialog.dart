import 'package:flutter/material.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color? confirmColor;
  final Widget? input;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
    this.input,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    Widget? input,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: title,
          message: message,
          onConfirm: onConfirm,
          confirmText: confirmText,
          cancelText: cancelText,
          confirmColor: confirmColor,
          input: input,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final primaryColor = confirmColor ?? theme.colors.primary;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyMedium.copyWith(
              // ignore: deprecated_member_use
              color: theme.colors.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (input != null) ...[const SizedBox(height: 20), input!],
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: primaryColor),
                  ),
                  child: Text(
                    cancelText,
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: TextStyle(color: theme.colors.onPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
