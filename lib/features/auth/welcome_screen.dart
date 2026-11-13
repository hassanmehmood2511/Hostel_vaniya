import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';
import '../shared/appearance.dart';

/// Screen 1 — brand welcome.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Soft lime glow behind the mark.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.25),
                  radius: 0.8,
                  colors: <Color>[
                    AppColors.primary.withValues(alpha: 0.10),
                    AppColors.background.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: SquareIconButton(
                      icon: AppColors.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      tooltip: 'Appearance',
                      onPressed: () => showAppearanceSheet(context),
                    ),
                  ),
                  const Spacer(flex: 3),
                  const BrandMark(size: 88),
                  const SizedBox(height: AppSpacing.xl),
                  const Wordmark(fontSize: 32),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Find your hostel near campus', style: AppText.bodySecondary.copyWith(fontSize: 15)),
                  const Spacer(flex: 4),
                  AppButton(
                    label: 'Get started',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'I already have an account',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
