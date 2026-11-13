import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

/// Screen 18 — owner's hostels.
class MyHostelsScreen extends StatelessWidget {
  const MyHostelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Hostel h = MockData.alNoor;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        TabHeader(
          title: 'My hostels',
          actions: <Widget>[
            SquareIconButton(
              icon: Icons.add_rounded,
              tooltip: 'Add hostel',
              highlighted: true,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.editHostel),
            ),
          ],
        ),
        Padding(
          padding: AppSpacing.screen,
          child: SurfaceCard(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 150,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(child: PhotoPlaceholder(label: 'Cover photo')),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Row(
                          children: <Widget>[
                            StatusBadge(label: 'Live', tone: BadgeTone.success),
                            SizedBox(width: 6),
                            VerifiedBadge(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(h.name, style: AppText.h3),
                      const SizedBox(height: 2),
                      Text(
                        '${h.rooms.length} room types · ${h.freeBeds} beds available',
                        style: AppText.caption,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: <Widget>[
                          _Metric(label: 'Views', value: Fmt.count(h.views)),
                          _Metric(label: 'Contacts', value: Fmt.count(h.contacts)),
                          _Metric(label: 'Rating', value: h.rating.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AppButton(
                              label: 'Edit',
                              icon: Icons.edit_outlined,
                              compact: true,
                              variant: AppButtonVariant.secondary,
                              onPressed: () =>
                                  Navigator.pushNamed(context, AppRoutes.editHostel, arguments: h.id),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: AppButton(
                              label: 'Rooms and rates',
                              compact: true,
                              onPressed: () =>
                                  Navigator.pushNamed(context, AppRoutes.manageRooms, arguments: h.id),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: AppSpacing.screen,
          child: SurfaceCard(
            padding: const EdgeInsets.all(12),
            onTap: () => Navigator.pushNamed(
              context, AppRoutes.editHostel, arguments: MockData.alNoorAnnex.id,
            ),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 56, height: 56, child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: Text(MockData.alNoorAnnex.name, style: AppText.title)),
                          const StatusBadge(label: 'In review', tone: BadgeTone.warning),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Admin usually reviews within 24 hours.', style: AppText.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: AppSpacing.screen,
          child: InkWell(
            borderRadius: AppRadius.lgAll,
            onTap: () => Navigator.pushNamed(context, AppRoutes.editHostel),
            child: Container(
              height: 96,
              decoration: BoxDecoration(
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add_rounded, color: AppColors.accent),
                  const SizedBox(height: 4),
                  Text('Add another hostel', style: AppText.title),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: AppText.caption),
          const SizedBox(height: 2),
          Text(value, style: AppText.h3),
        ],
      ),
    );
  }
}
