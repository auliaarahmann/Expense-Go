// lib/features/profile/presentation/widgets/profile_settings_tile.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';

class ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isDestructive
                          ? theme.colors.error
                          : theme.colors.primary.withOpacity(0.2))
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color:
                      isDestructive ? theme.colors.error : theme.colors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color:
                            isDestructive
                                ? theme.colors.error
                                : theme.colors.onBackground,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall.copyWith(
                          color: theme.colors.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colors.onBackground.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
