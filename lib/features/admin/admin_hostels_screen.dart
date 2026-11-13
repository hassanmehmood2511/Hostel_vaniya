import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

class _Listing {
  const _Listing(this.id, this.name, this.owner, this.area, this.status);
  final String id;
  final String name;
  final String owner;
  final String area;
  final ListingStatus status;
}

StatusBadge listingBadge(ListingStatus s) => switch (s) {
      ListingStatus.live => const StatusBadge(label: 'Live', tone: BadgeTone.success),
      ListingStatus.pending => const StatusBadge(label: 'Pending', tone: BadgeTone.warning),
      ListingStatus.suspended => const StatusBadge(label: 'Suspended', tone: BadgeTone.danger),
    };

/// Screen 27 — all hostels (admin).
class AdminHostelsScreen extends StatefulWidget {
  const AdminHostelsScreen({super.key});

  @override
  State<AdminHostelsScreen> createState() => _AdminHostelsScreenState();
}

class _AdminHostelsScreenState extends State<AdminHostelsScreen> {
  ListingStatus? _filter;
  String _query = '';

  static const List<_Listing> _all = <_Listing>[
    _Listing('al-noor', 'Al-Noor Boys Hostel', 'Rashid Mehmood', 'Model Town A', ListingStatus.live),
    _Listing('iqra', 'Iqra Girls Hostel', 'Nadia Bibi', 'Satellite Town', ListingStatus.live),
    _Listing('cholistan', 'Cholistan Residency', 'Imran Ali', 'Satellite Town', ListingStatus.live),
    _Listing('al-noor-annex', 'Al-Noor Annex', 'Rashid Mehmood', 'Model Town A', ListingStatus.pending),
    _Listing('green-view', 'Green View Hostel', 'Unknown owner', 'Baghdad Road', ListingStatus.suspended),
    _Listing('model-town', 'Model Town Boys Hostel', 'Tariq Javed', 'Model Town B', ListingStatus.live),
  ];

  @override
  Widget build(BuildContext context) {
    final String q = _query.toLowerCase();
    final List<_Listing> list = _all
        .where((_Listing l) => _filter == null || l.status == _filter)
        .where((_Listing l) => q.isEmpty ||
            '${l.name} ${l.owner} ${l.area}'.toLowerCase().contains(q))
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'Hostels'),
        Padding(
          padding: AppSpacing.screen,
          child: TextField(
            onChanged: (String v) => setState(() => _query = v),
            style: AppText.body,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Search by name, owner or area',
              prefixIcon: Icon(Icons.search_rounded, size: 20),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PillRow(
          children: <Widget>[
            SelectPill(label: 'All · 232', selected: _filter == null, onTap: () => setState(() => _filter = null)),
            SelectPill(
              label: 'Live · 214', selected: _filter == ListingStatus.live,
              onTap: () => setState(() => _filter = ListingStatus.live),
            ),
            SelectPill(
              label: 'Pending · 12', selected: _filter == ListingStatus.pending,
              onTap: () => setState(() => _filter = ListingStatus.pending),
            ),
            SelectPill(
              label: 'Suspended · 6', selected: _filter == ListingStatus.suspended,
              onTap: () => setState(() => _filter = ListingStatus.suspended),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (list.isEmpty)
          const EmptyState(
            icon: Icons.search_off_rounded, title: 'No hostels found', message: 'Try a different name or area.',
          ),
        for (final _Listing l in list)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs),
            child: SurfaceCard(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              onTap: () => Navigator.pushNamed(context, AppRoutes.hostelDetail, arguments: l.id),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 48, height: 48, child: PhotoPlaceholder(showLabel: false, iconSize: 16)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(l.name, style: AppText.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('${l.owner} · ${l.area}', style: AppText.caption, maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  listingBadge(l.status),
                  PopupMenuButton<String>(
                    tooltip: 'More actions',
                    color: AppColors.surfaceHigh,
                    icon: Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                    onSelected: (String v) => showAppSnack(context, '$v · ${l.name}', icon: Icons.info_outline),
                    itemBuilder: (_) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(value: 'View listing', child: Text('View listing')),
                      const PopupMenuItem<String>(value: 'Contact owner', child: Text('Contact owner')),
                      PopupMenuItem<String>(
                        value: l.status == ListingStatus.suspended ? 'Restored' : 'Suspended',
                        child: Text(
                          l.status == ListingStatus.suspended ? 'Restore' : 'Suspend',
                          style: TextStyle(
                            color: l.status == ListingStatus.suspended ? AppColors.success : AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
