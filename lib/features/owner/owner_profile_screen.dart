import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';
import '../shared/appearance.dart';
import '../shared/logout.dart';

/// Screen 24 — owner profile.
class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  bool _alerts = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'Profile'),
        Padding(
          padding: AppSpacing.screen,
          child: Row(
            children: <Widget>[
              const InitialsAvatar(name: MockData.ownerName, size: 64, highlight: true),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(MockData.ownerName, style: AppText.h2),
                    const SizedBox(height: 6),
                    const Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: <Widget>[
                        const StatusBadge(label: '2 hostels', tone: BadgeTone.neutral),
                        const StatusBadge(label: 'Verification pending', tone: BadgeTone.warning),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: AppSpacing.screen,
          child: SurfaceCard(
            borderColor: AppColors.accent,
            onTap: () => Navigator.pushNamed(context, AppRoutes.verification),
            child: Row(
              children: <Widget>[
                Icon(Icons.verified_user_outlined, color: AppColors.accent),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Finish verification', style: AppText.title),
                      Text('2 documents left to upload', style: AppText.caption),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.accent),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SettingsTile(icon: Icons.call_outlined, title: 'Contact numbers', value: '0300 1234567', onTap: () {}),
        SettingsTile(icon: Icons.business_center_outlined, title: 'Business details', onTap: () {}),
        SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: 'Request alerts',
          trailing: Switch(value: _alerts, onChanged: (bool v) => setState(() => _alerts = v)),
          onTap: () => setState(() => _alerts = !_alerts),
        ),
        const AppearanceTile(),
        SettingsTile(icon: Icons.language_rounded, title: 'Language', value: 'English', onTap: () {}),
        SettingsTile(icon: Icons.help_outline_rounded, title: 'Help and support', onTap: () {}),
        const Padding(padding: AppSpacing.screen, child: Divider()),
        SettingsTile(
          icon: Icons.logout_rounded,
          title: 'Log out',
          destructive: true,
          onTap: () => confirmLogout(context),
        ),
      ],
    );
  }
}
