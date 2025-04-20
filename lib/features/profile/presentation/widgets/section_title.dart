// lib/features/profile/presentation/widgets/section_title.dart

import 'package:flutter/material.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const SectionTitle({super.key, required this.title, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTheme.of(context).textTheme.labelSmall.copyWith(
            // ignore: deprecated_member_use
            color: AppTheme.of(context).colors.onBackground.withOpacity(0.6),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
