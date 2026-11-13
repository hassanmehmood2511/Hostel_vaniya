import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_controller.dart';
import '../../widgets/common.dart';

/// Settings row that shows the current theme and opens the picker.
class AppearanceTile extends StatelessWidget {
  const AppearanceTile({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController c = ThemeController.instance;
    return ListenableBuilder(
      listenable: c,
      builder: (BuildContext context, _) => SettingsTile(
        icon: AppColors.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        title: 'Appearance',
        value: ThemeController.labelFor(c.mode),
        onTap: () => showAppearanceSheet(context),
      ),
    );
  }
}

Future<void> showAppearanceSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext ctx) => const _AppearanceSheet(),
  );
}

class _AppearanceSheet extends StatelessWidget {
  const _AppearanceSheet();

  static const List<(ThemeMode, IconData, String)> _options = <(ThemeMode, IconData, String)>[
    (ThemeMode.system, Icons.brightness_auto_outlined, 'Match your phone\'s setting'),
    (ThemeMode.light, Icons.light_mode_outlined, 'Bright background, best outdoors'),
    (ThemeMode.dark, Icons.dark_mode_outlined, 'Easier on the eyes at night'),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController c = ThemeController.instance;
    return SafeArea(
      child: ListenableBuilder(
        listenable: c,
        builder: (BuildContext context, _) => Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Appearance', style: AppText.h2),
              const SizedBox(height: AppSpacing.md),
              for (final (ThemeMode mode, IconData icon, String hint) in _options) ...<Widget>[
                _ModeOption(
                  icon: icon,
                  title: ThemeController.labelFor(mode),
                  subtitle: hint,
                  selected: c.mode == mode,
                  onTap: () => c.setMode(mode),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: SurfaceCard(
        onTap: onTap,
        color: AppColors.background,
        borderColor: selected ? AppColors.accent : AppColors.border,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: <Widget>[
            Icon(icon, color: selected ? AppColors.accent : AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppText.title),
                  Text(subtitle, style: AppText.caption),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
