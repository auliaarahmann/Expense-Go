// lib/features/profile/presentation/widgets/dialogs/settings_dialog.dart

import 'package:flutter/material.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';

class SettingsDialog extends StatelessWidget {
  final bool initialDarkMode;
  final String initialTheme;
  final String initialLanguage;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onSave;

  const SettingsDialog({
    super.key,
    required this.initialDarkMode,
    required this.initialTheme,
    required this.initialLanguage,
    required this.onDarkModeChanged,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required bool initialDarkMode,
    required String initialTheme,
    required String initialLanguage,
    required ValueChanged<bool> onDarkModeChanged,
    required ValueChanged<String> onThemeChanged,
    required ValueChanged<String> onLanguageChanged,
    required VoidCallback onSave,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SettingsDialog(
            initialDarkMode: initialDarkMode,
            initialTheme: initialTheme,
            initialLanguage: initialLanguage,
            onDarkModeChanged: onDarkModeChanged,
            onThemeChanged: onThemeChanged,
            onLanguageChanged: onLanguageChanged,
            onSave: onSave,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return StatefulBuilder(
      builder: (context, setState) {
        bool darkMode = initialDarkMode;
        String selectedTheme = initialTheme;
        String selectedLanguage = initialLanguage;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildDarkModeSwitch(
                  context,
                  darkMode,
                  (value) => setState(() => darkMode = value),
                ),
                const SizedBox(height: 16),
                _buildThemeSelector(
                  context,
                  selectedTheme,
                  (value) => setState(() => selectedTheme = value!),
                ),
                const SizedBox(height: 16),
                _buildLanguageSelector(
                  context,
                  selectedLanguage,
                  (value) => setState(() => selectedLanguage = value!),
                ),
                const SizedBox(height: 24),
                _buildSaveButton(theme, context, () {
                  onDarkModeChanged(darkMode);
                  onThemeChanged(selectedTheme);
                  onLanguageChanged(selectedLanguage);
                  onSave();
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('App Settings', style: Theme.of(context).textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDarkModeSwitch(
    BuildContext context,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        const Icon(Icons.dark_mode, size: 24),
        const SizedBox(width: 16),
        Text('Dark Mode', style: AppTheme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.of(context).colors.primary,
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      children: [
        const Icon(Icons.palette, size: 24),
        const SizedBox(width: 16),
        Text('Theme Color', style: AppTheme.of(context).textTheme.bodyLarge),
        const Spacer(),
        DropdownButton<String>(
          value: value,
          items: const [
            DropdownMenuItem(value: 'Indigo', child: Text('Indigo')),
            DropdownMenuItem(value: 'Blue', child: Text('Blue')),
            DropdownMenuItem(value: 'Green', child: Text('Green')),
            DropdownMenuItem(value: 'Purple', child: Text('Purple')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      children: [
        const Icon(Icons.language, size: 24),
        const SizedBox(width: 16),
        Text('Language', style: AppTheme.of(context).textTheme.bodyLarge),
        const Spacer(),
        DropdownButton<String>(
          value: value,
          items: const [
            DropdownMenuItem(value: 'English', child: Text('English')),
            DropdownMenuItem(
              value: 'Bahasa Indonesia',
              child: Text('Bahasa Indonesia'),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    AppTheme theme,
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          'Save Preferences',
          style: TextStyle(color: theme.colors.onPrimary),
        ),
      ),
    );
  }
}
