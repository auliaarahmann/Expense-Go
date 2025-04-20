// lib/features/profile/presentation/widgets/profile_header.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colors.primary,
            theme.colors.primaryDark,
            theme.colors.primary.withOpacity(0.8),
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
                                (_, __, ___) => _buildDefaultAvatar(theme),
                          )
                          : _buildDefaultAvatar(theme),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: theme.colors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user.name ?? 'Update your name',
            style: theme.textTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user.email ?? 'No email provided',
            style: theme.textTheme.bodyMedium.copyWith(
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

  Widget _buildDefaultAvatar(AppTheme theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colors.primary, theme.colors.primaryDark],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 50,
          color: theme.colors.onPrimary,
        ),
      ),
    );
  }
}
