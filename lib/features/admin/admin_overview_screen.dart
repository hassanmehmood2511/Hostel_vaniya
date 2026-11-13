import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';
import '../shared/appearance.dart';
import '../shared/logout.dart';

/// Screen 25 — admin overview.
class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        TabHeader(
          overline: 'Admin panel',
          title: 'Overview',
          actions: <Widget>[
            PopupMenuButton<String>(
              tooltip: 'Settings',
              color: AppColors.surfaceHigh,
              onSelected: (String v) {
                if (v == 'cities') Navigator.pushNamed(context, AppRoutes.cities);
                if (v == 'appearance') showAppearanceSheet(context);
                if (v == 'logout') confirmLogout(context);
              },
              itemBuilder: (_) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'cities',
                  child: ListTile(
                    leading: Icon(Icons.location_city_rounded),
                    title: Text('Cities and universities'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'appearance',
                  child: ListTile(
                    leading: Icon(Icons.contrast_rounded),
                    title: Text('Appearance'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout_rounded, color: AppColors.danger),
                    title: Text('Log out', style: TextStyle(color: AppColors.danger)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.settings_outlined, size: 20),
              ),
            ),
          ],
        ),
        Padding(
          padding: AppSpacing.screen,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.3,
            children: <Widget>[
              const StatCard(label: 'Students', value: '3,420', icon: Icons.school_outlined, delta: '+140 this week'),
              const StatCard(label: 'Hostel owners', value: '186', icon: Icons.badge_outlined, delta: '+9 this week'),
              const StatCard(label: 'Live hostels', value: '214', icon: Icons.apartment_outlined, delta: '+6 this week'),
              StatCard(
                label: 'Pending approvals',
                value: '12',
                icon: Icons.pending_actions_outlined,
                delta: 'Oldest: 2 days',
                deltaColor: AppColors.warning,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: AppSpacing.screen,
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text('New signups', style: AppText.h3)),
                    Text('Last 7 days', style: AppText.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const WeeklyBarChart(values: MockData.adminWeeklySignups),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Needs attention'),
        const SizedBox(height: AppSpacing.xs),
        _AttentionTile(
          icon: Icons.verified_outlined,
          title: '12 hostels waiting for approval',
          subtitle: '8 new listings, 4 edits',
          onTap: () => AppState.instance.adminTab.value = 1,
        ),
        _AttentionTile(
          icon: Icons.flag_outlined,
          title: '5 reports from students',
          subtitle: '2 marked as fake listing',
          onTap: () => AppState.instance.adminTab.value = 4,
          tone: BadgeTone.danger,
        ),
      ],
    );
  }
}

class _AttentionTile extends StatelessWidget {
  const _AttentionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.tone = BadgeTone.warning,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
      child: SurfaceCard(
        padding: const EdgeInsets.all(12),
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.surfaceHigh, borderRadius: AppRadius.mdAll),
              child: Icon(icon, color: AppColors.accent, size: 20),
            ),
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
            StatusBadge(label: 'Open', tone: tone),
          ],
        ),
      ),
    );
  }
}
