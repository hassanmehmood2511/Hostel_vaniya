import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

/// Screen 17 — owner dashboard.
class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<VisitRequest> newRequests = MockData.ownerRequests
        .where((VisitRequest r) => r.status == RequestStatus.pending)
        .toList();
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        TabHeader(
          overline: 'Hostel owner',
          title: 'Hi, ${MockData.ownerFirstName}',
          actions: <Widget>[
            SquareIconButton(
              icon: Icons.notifications_none_rounded,
              tooltip: 'Notifications',
              badge: true,
              onPressed: () => AppState.instance.ownerTab.value = 2,
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
              StatCard(
                label: 'Profile views',
                value: Fmt.count(MockData.alNoor.views),
                icon: Icons.visibility_outlined,
                delta: '+12% this week',
              ),
              const StatCard(label: 'Call taps', value: '86', icon: Icons.call_outlined, delta: '+8 this week'),
              const StatCard(
                label: 'WhatsApp taps', value: '142', icon: Icons.chat_outlined, delta: '+21 this week',
              ),
              StatCard(
                label: 'Visit requests',
                value: '9',
                icon: Icons.event_note_outlined,
                delta: '${newRequests.length} new',
                deltaColor: AppColors.accent,
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
                    Expanded(child: Text('Views this week', style: AppText.h3)),
                    Text(MockData.alNoor.name, style: AppText.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const WeeklyBarChart(values: MockData.ownerWeeklyViews),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(
          title: 'New visit requests',
          action: 'See all',
          onAction: () => AppState.instance.ownerTab.value = 2,
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final VisitRequest r in newRequests)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: SurfaceCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  InitialsAvatar(name: r.studentName),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(r.studentName, style: AppText.title),
                        Text('${r.room} · ${r.when}', style: AppText.caption),
                      ],
                    ),
                  ),
                  RoundActionButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Decline',
                    foreground: AppColors.danger,
                    onPressed: () => showAppSnack(context, 'Request from ${r.studentName} declined',
                        icon: Icons.close),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  RoundActionButton(
                    icon: Icons.check_rounded,
                    tooltip: 'Accept',
                    background: AppColors.primary,
                    foreground: AppColors.onPrimary,
                    onPressed: () => showAppSnack(context, 'Visit confirmed. ${r.studentName} has been notified.'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
