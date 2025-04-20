// lib/features/profile/presentation/widgets/dialogs/edit_name_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensego/core/presentation/widgets/inputs/custom_text_field.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';
import 'package:expensego/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';

class EditNameDialog extends StatelessWidget {
  final UserEntity user;

  const EditNameDialog({super.key, required this.user});

  static Future<void> show(BuildContext context, UserEntity user) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => EditNameDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _EditNameForm(user: user),
    );
  }
}

class _EditNameForm extends StatefulWidget {
  final UserEntity user;

  const _EditNameForm({required this.user});

  @override
  State<_EditNameForm> createState() => _EditNameFormState();
}

class _EditNameFormState extends State<_EditNameForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.user.name);

  @override
  void dispose() {
    _nameController.dispose();
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
            _buildNameField(),
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
          'Edit Profile',
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

  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      labelText: 'Full Name',
      prefixIcon: Icons.person_outline_rounded,
      validator:
          (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
    );
  }

  Widget _buildSubmitButton(AppTheme theme) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.lightGreen,
              content: Text('Profile updated successfully'),
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
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                          UpdateProfileRequested(
                            ProfileEntity(
                              uid: widget.user.uid,
                              name: _nameController.text.trim(),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
            child:
                state is ProfileLoading
                    ? CircularProgressIndicator(color: theme.colors.onPrimary)
                    : Text(
                      'Save Changes',
                      style: TextStyle(color: theme.colors.onPrimary),
                    ),
          ),
        );
      },
    );
  }
}
