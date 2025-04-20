import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensego/core/presentation/widgets/inputs/custom_text_field.dart';
import 'package:expensego/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const _ChangePasswordForm(),
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm();

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildCurrentPasswordField(),
            const SizedBox(height: 16),
            _buildNewPasswordField(),
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
            const SizedBox(height: 24),
            _buildSubmitButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Change Password',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return CustomTextField(
      controller: _currentPasswordController,
      labelText: 'Current Password',
      prefixIcon: Icons.lock_outline,
      obscureText: !_showCurrentPassword,
      validator:
          (value) =>
              value?.isEmpty ?? true ? 'Please enter current password' : null,
      suffixIcon: IconButton(
        icon: Icon(
          _showCurrentPassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _showCurrentPassword = !_showCurrentPassword;
          });
        },
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return CustomTextField(
      controller: _newPasswordController,
      labelText: 'New Password',
      prefixIcon: Icons.lock,
      obscureText: !_showNewPassword,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter new password';
        if (value.length < 6) return 'Minimum 6 characters';
        return null;
      },
      suffixIcon: IconButton(
        icon: Icon(
          _showNewPassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _showNewPassword = !_showNewPassword;
          });
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      controller: _confirmPasswordController,
      labelText: 'Confirm Password',
      prefixIcon: Icons.lock_reset,
      obscureText: !_showConfirmPassword,
      validator:
          (value) =>
              value != _newPasswordController.text
                  ? 'Passwords do not match'
                  : null,
      suffixIcon: IconButton(
        icon: Icon(
          _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _showConfirmPassword = !_showConfirmPassword;
          });
        },
      ),
    );
  }

  Widget _buildSubmitButton(AppTheme theme) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Password updated successfully'),
            ),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                state is ProfileLoading
                    ? null
                    : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProfileBloc>().add(
                          ChangePasswordRequested(
                            currentPassword: _currentPasswordController.text,
                            newPassword: _newPasswordController.text,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
            child:
                state is ProfileLoading
                    ? const CircularProgressIndicator()
                    : Text(
                      'Update Password',
                      style: TextStyle(color: theme.colors.onPrimary),
                    ),
          ),
        );
      },
    );
  }
}
