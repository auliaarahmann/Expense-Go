// lib/features/profile/presentation/pages/profile_page.dart

import 'package:expensego/features/auth/domain/entities/user_entity.dart';
import 'package:expensego/features/profile/presentation/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensego/core/presentation/widgets/indicators/loading_indicator.dart';
import 'package:expensego/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:expensego/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:expensego/features/profile/presentation/widgets/profile_header.dart';
import 'package:expensego/features/profile/presentation/widgets/profile_settings_tile.dart';
import 'package:expensego/features/profile/presentation/widgets/section_title.dart';
import 'package:expensego/features/profile/presentation/widgets/dialogs/edit_name_dialog.dart';
import 'package:expensego/features/profile/presentation/widgets/dialogs/change_password_dialog.dart';
import 'package:expensego/features/profile/presentation/widgets/dialogs/settings_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccess) {
                context.read<AuthBloc>().add(RefreshUserRequested());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.lightGreen,
                    duration: Duration(seconds: 3),
                    content: Text('Profile updated successfully'),
                  ),
                );
              }
              if (state is ChangePasswordSuccess) {
                context.read<AuthBloc>().add(RefreshUserRequested());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.lightGreen,
                    duration: Duration(seconds: 3),
                    content: Text('Password changed successfully'),
                  ),
                );
              }

              if (state is AccountDeletedSuccessfully) {
                context.read<AuthBloc>().add(SignOutRequested());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.lightGreen,
                    duration: Duration(seconds: 3),
                    content: Text('Your account has been permanently deleted.'),
                  ),
                );
              }
              if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                    content: Text(state.message),
                  ),
                );
              }
            },
          ),

          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignOutSuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.lightGreen,
                    duration: Duration(seconds: 3),
                    content: Text('You have signed out.'),
                  ),
                );

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }

              if (state is Unauthenticated) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is Unauthenticated) {
              return const Center(child: Text('Please log in to view profile'));
            }

            if (authState is Authenticated) {
              return _ProfileContent(user: authState.user);
            }

            return const Center(child: LoadingIndicator());
          },
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserEntity user;

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeader(user: user),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SectionTitle(title: 'Account Settings'),
                ProfileSettingsTile(
                  icon: Icons.edit,
                  title: 'Update Profile',
                  subtitle: 'Change your name',
                  onTap: () => EditNameDialog.show(context, user),
                ),
                ProfileSettingsTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => ChangePasswordDialog.show(context),
                ),
                const SectionTitle(title: 'App Preferences'),
                ProfileSettingsTile(
                  icon: Icons.palette,
                  title: 'Theme & Appearance',
                  subtitle: 'Change theme color, dark mode, and language',
                  onTap: () => _showAppearanceSettings(context),
                ),
                const SectionTitle(title: 'Danger Zone'),
                ProfileSettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  isDestructive: true,
                  onTap: () => _showDeleteAccountConfirmation(context),
                ),
                const SectionTitle(title: 'SIGNING OUT'),
                ProfileSettingsTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Sign out from your account',
                  isDestructive: true,
                  onTap: () => _showSignOutConfirmation(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAppearanceSettings(BuildContext context) {
    SettingsDialog.show(
      context: context,
      initialDarkMode: false,
      initialTheme: 'Indigo',
      initialLanguage: 'English',
      onDarkModeChanged: (value) {
        // Handle dark mode change
      },
      onThemeChanged: (theme) {
        // Handle theme change
      },
      onLanguageChanged: (language) {
        // Handle language change
      },
      onSave: () {
        // Save settings
      },
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    ConfirmDialog.show(
      context: context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Me Out',
      onConfirm: () => context.read<AuthBloc>().add(SignOutRequested()),
      confirmColor: Colors.red,
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    if (authState is! Authenticated || authState.user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email not found, please login again.')),
      );
      return;
    }

    final email = authState.user.email!;

    final controller = TextEditingController();

    ConfirmDialog.show(
      context: context,
      title: 'Delete Account',
      message:
          'This will permanently delete all your data. '
          'This action cannot be undone.',
      confirmText: 'Delete!',
      confirmColor: Colors.red,
      input: TextField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Enter your password',
          border: OutlineInputBorder(),
        ),
      ),
      onConfirm: () {
        final password = controller.text.trim();
        if (password.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Password is required')));
          return;
        }

        context.read<ProfileBloc>().add(
          DeleteAccountRequested(email: email, password: password),
        );
      },
    );
  }
}
