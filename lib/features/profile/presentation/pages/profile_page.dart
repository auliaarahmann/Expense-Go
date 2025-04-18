import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';
import 'package:expensego/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:expensego/features/profile/presentation/blocs/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            context.read<AuthBloc>().add(RefreshUserRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.lightGreen,
              ),
            );
          }
          // Tambahkan penanganan untuk status Unauthenticated
          if (state is Unauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', // Sesuaikan dengan route
              (route) => false,
            );
          }
        },
        builder: (context, profileState) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return _ProfileContent(user: authState.user);
              }
              return const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserEntity user;

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _Header(user: user),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                _SectionTitle(title: 'Account Settings'),
                _buildTile(
                  context,
                  icon: Icons.edit_rounded,
                  title: 'Update Profile',
                  subtitle: 'Change your name',
                  onTap: () => _EditNameSheet.show(context, user),
                  iconColor: Colors.indigo,
                ),
                _buildTile(
                  context,
                  icon: Icons.lock_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => _ChangePasswordSheet.show(context),
                  iconColor: Colors.indigo,
                ),
                const SizedBox(height: 8),
                _SectionTitle(title: 'App Preferences'),
                _buildTile(
                  context,
                  icon: Icons.palette_rounded,
                  title: 'Theme & Appearance',
                  subtitle: 'Change theme color and dark mode',
                  onTap:
                      () => _SettingSheet.show(
                        context,
                        isDarkMode: false,
                        selectedTheme: 'Indigo',
                        selectedLanguage: 'English',
                        onDarkModeChanged: (val) {},
                        onThemeChanged: (theme) {},
                        onLanguageChanged: (lang) {},
                        onSave: () {},
                      ),
                  iconColor: Colors.indigo,
                ),
                _buildTile(
                  context,
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'Change app language',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Language selection coming soon'),
                        backgroundColor: Colors.indigo,
                      ),
                    );
                  },
                  iconColor: Colors.indigo,
                ),
                const SizedBox(height: 24),
                _buildTile(
                  context,
                  icon: Icons.delete_forever_rounded,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  onTap:
                      () => _ConfirmSheet.show(
                        context,
                        'Delete Account',
                        'Are you sure you want to delete your account? This action cannot be undone.',
                        () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Feature is not available yet.'),
                              backgroundColor: Colors.indigo,
                            ),
                          );
                        },
                      ),
                  iconColor: Colors.red,
                  textColor: Colors.red,
                ),
                _buildTile(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  subtitle: 'Log out from your account',
                  onTap:
                      () => _ConfirmSheet.show(
                        context,
                        'Sign Out',
                        'Are you sure you want to sign out?',
                        () {
                          context.read<AuthBloc>().add(SignOutRequested());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('You have been signed out'),
                              backgroundColor: Colors.lightGreen,
                            ),
                          );
                        },
                      ),
                  iconColor: Colors.red,
                  textColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.indigo).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor ?? Colors.indigo, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textColor ?? theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UserEntity user;

  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo,
            Colors.indigo.shade700,
            Colors.indigo.shade500,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child:
                      user.photoUrl != null
                          ? Image.network(
                            user.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    _buildDefaultAvatar(),
                          )
                          : _buildDefaultAvatar(),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user.name ?? 'Update your name.',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user.email ?? 'No Email',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white,
                  Colors.white.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo, Colors.indigoAccent]),
      ),
      child: const Center(
        child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
      ),
    );
  }
}

class _EditNameSheet {
  static void show(BuildContext context, UserEntity user) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user.name);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Profile',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser == null) return;

                          if (!formKey.currentState!.validate()) return;

                          final updatedName = nameController.text.trim();
                          context.read<ProfileBloc>().add(
                            UpdateProfileRequested(
                              ProfileEntity(
                                uid: currentUser.uid,
                                name: updatedName,
                              ),
                            ),
                          );

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChangePasswordSheet {
  static void show(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;
    String? currentPasswordError;
    String? newPasswordError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Change Password',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed:
                                  isLoading
                                      ? null
                                      : () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            errorText: currentPasswordError,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.lock_rounded),
                            errorText: newPasswordError,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.lock_reset_rounded),
                          ),
                          validator: (value) {
                            if (value != newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () async {
                                      // Reset previous errors
                                      setState(() {
                                        currentPasswordError = null;
                                        newPasswordError = null;
                                      });

                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }

                                      setState(() => isLoading = true);

                                      try {
                                        final currentUser =
                                            FirebaseAuth.instance.currentUser;
                                        if (currentUser == null) {
                                          throw FirebaseAuthException(
                                            code: 'user-not-found',
                                            message: 'User not found',
                                          );
                                        }

                                        // Reauthenticate user
                                        final credential =
                                            EmailAuthProvider.credential(
                                              email: currentUser.email!,
                                              password:
                                                  currentPasswordController.text
                                                      .trim(),
                                            );
                                        await currentUser
                                            .reauthenticateWithCredential(
                                              credential,
                                            );

                                        // Update password
                                        await currentUser.updatePassword(
                                          newPasswordController.text.trim(),
                                        );

                                        // Close the bottom sheet
                                        Navigator.pop(context);

                                        // Show success message
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Password updated successfully',
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.lightGreen,
                                          ),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        setState(() {
                                          switch (e.code) {
                                            case 'wrong-password':
                                              currentPasswordError =
                                                  'Incorrect current password';
                                              break;
                                            case 'weak-password':
                                              newPasswordError =
                                                  'Password is too weak';
                                              break;
                                            case 'requires-recent-login':
                                              currentPasswordError =
                                                  'Please reauthenticate';
                                              break;
                                            default:
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Error: ${e.message ?? 'Authentication failed'}',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                          }
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'An unknown error occurred',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        if (context.mounted) {
                                          setState(() => isLoading = false);
                                        }
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                    : const Text(
                                      'Update Password',
                                      style: TextStyle(color: Colors.white),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SettingSheet {
  static void show(
    BuildContext context, {
    required bool isDarkMode,
    required String selectedTheme,
    required String selectedLanguage,
    required void Function(bool) onDarkModeChanged,
    required void Function(String) onThemeChanged,
    required void Function(String) onLanguageChanged,
    required VoidCallback onSave,
  }) {
    final themeOptions = ['Indigo', 'Blue', 'Green', 'Purple'];
    final languageOptions = ['English', 'Bahasa Indonesia'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String tempTheme = selectedTheme;
        String tempLang = selectedLanguage;
        bool tempDarkMode = isDarkMode;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'App Settings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.dark_mode_rounded, size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Dark Mode',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: tempDarkMode,
                                    onChanged: (value) {
                                      setState(() => tempDarkMode = value);
                                    },
                                    activeColor: Colors.indigo,
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.palette_rounded, size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Theme Color',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Spacer(),
                                  DropdownButton<String>(
                                    value: tempTheme,
                                    underline: const SizedBox(),
                                    items:
                                        themeOptions.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => tempTheme = value);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.language_rounded, size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Language',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Spacer(),
                                  DropdownButton<String>(
                                    value: tempLang,
                                    underline: const SizedBox(),
                                    items:
                                        languageOptions.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => tempLang = value);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            onDarkModeChanged(tempDarkMode);
                            onThemeChanged(tempTheme);
                            onLanguageChanged(tempLang);
                            Navigator.pop(context);
                            onSave();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Preferences',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ConfirmSheet {
  static void show(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
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
                        side: BorderSide(color: Colors.indigo),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.indigo),
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
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
