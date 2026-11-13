import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/hostel_cards.dart';
import '../../widgets/scaffolds.dart';
import 'widgets/contact_actions.dart';

/// Screen 11 — rooms and rates.
class RoomsRatesScreen extends StatelessWidget {
  const RoomsRatesScreen({super.key, required this.hostel});
  final Hostel hostel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(title: 'Rooms and rates', subtitle: hostel.name),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xl),
        children: <Widget>[
          for (final RoomType r in hostel.rooms) ...<Widget>[
            _RoomCard(room: r),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.xs),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Included in rent', style: AppText.h3),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: <Widget>[
                    for (final Facility f in hostel.facilities)
                      FacilityChip(
                        label: f.label == 'Meals'
                            ? '${hostel.meals} meals daily'
                            : f.label == 'Laundry'
                                ? 'Laundry 2x/week'
                                : f.label,
                        icon: f.icon,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                const Divider(),
                const SizedBox(height: AppSpacing.xs),
                const InfoRow(label: 'Electricity', value: 'Shared, split monthly'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Row(
          children: <Widget>[
            SquareIconButton(
              icon: Icons.chat_rounded,
              tooltip: 'WhatsApp owner',
              size: 52,
              onPressed: () => whatsappOwner(context, hostel),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: AppButton(
                label: 'Request a visit',
                icon: Icons.calendar_month_rounded,
                onPressed: () => showRequestVisitSheet(context, hostel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room});
  final RoomType room;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: room.isFull ? 0.6 : 1,
      child: SurfaceCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 64, height: 64, child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Text(room.name, style: AppText.h3)),
                      room.isFull
                          ? const StatusBadge(label: 'Full', tone: BadgeTone.danger)
                          : StatusBadge(label: '${room.freeBeds} available', tone: BadgeTone.success),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(room.features, style: AppText.caption),
                  const SizedBox(height: 6),
                  PriceText(amount: room.rent, suffix: '/month per bed', size: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
