// lib/core/presentation/widgets/indicators/loading_indicator.dart

import 'package:flutter/material.dart';
import 'package:expensego/core/presentation/themes/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? theme.colors.primary,
          ),
        ),
      ),
    );
  }
}

class SmallLoadingIndicator extends StatelessWidget {
  final Color? color;

  const SmallLoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(size: 16, strokeWidth: 1.5);
  }
}

class ButtonLoadingIndicator extends StatelessWidget {
  final Color? color;

  const ButtonLoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(size: 20, strokeWidth: 2.0);
  }
}
