import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

/// Screen 13 — compare saved hostels side by side.
class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Hostel> items = AppState.instance.compare.value
        .map(AppState.instance.hostelById)
        .whereType<Hostel>()
        .toList();

    if (items.length < 2) {
      return const Scaffold(
        appBar: DetailAppBar(title: 'Compare hostels'),
        body: EmptyState(
          icon: Icons.compare_arrows_rounded,
          title: 'Pick at least 2 hostels',
          message: 'Go to Saved and tick the hostels you want to compare.',
        ),
      );
    }

    final List<_Row> rows = <_Row>[
      _Row('Rent (2-seater)', (Hostel h) => Fmt.rs(h.rentFor('2-seater')),
          best: (List<Hostel> l) => _minBy(l, (Hostel h) => h.rentFor('2-seater'))),
      _Row('Distance from IUB', (Hostel h) => Fmt.km(h.distanceKm),
          best: (List<Hostel> l) => _minBy(l, (Hostel h) => h.distanceKm)),
      _Row('Rating', (Hostel h) => '${h.rating} (${h.reviewCount})',
          best: (List<Hostel> l) => _minBy(l, (Hostel h) => -h.rating)),
      _Row('Meals included', (Hostel h) => '${h.meals} meals',
          best: (List<Hostel> l) => _minBy(l, (Hostel h) => -h.meals)),
      _Row('Wi-Fi', (Hostel h) => h.facilities.any((Facility f) => f.label == 'Wi-Fi') ? 'Yes' : 'No',
          isBool: true),
      _Row('AC rooms', (Hostel h) => h.ac ? 'Yes' : 'No', isBool: true),
      _Row('Curfew', (Hostel h) => h.curfew),
      _Row('Security deposit', (Hostel h) => Fmt.rs(h.deposit),
          best: (List<Hostel> l) => _minBy(l, (Hostel h) => h.deposit)),
    ];

    return Scaffold(
      appBar: const DetailAppBar(title: 'Compare hostels'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xl),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; i < items.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const AspectRatio(aspectRatio: 1.25, child: PhotoPlaceholder(showLabel: false)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(items[i].name, style: AppText.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final _Row row in rows) _CompareRow(row: row, items: items),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              Icon(Icons.circle, size: 8, color: AppColors.accent),
              const SizedBox(width: 6),
              Text('Better value highlighted', style: AppText.caption),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Row(
          children: <Widget>[
            for (int i = 0; i < items.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AppButton(
                  label: 'View ${items[i].name.split(' ').first}',
                  variant: AppButtonVariant.secondary,
                  compact: items.length > 2,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.hostelDetail, arguments: items[i].id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _minBy(List<Hostel> list, num Function(Hostel) key) =>
      list.reduce((Hostel a, Hostel b) => key(a) <= key(b) ? a : b).id;
}

class _Row {
  _Row(this.label, this.value, {this.best, this.isBool = false});
  final String label;
  final String Function(Hostel) value;
  final String Function(List<Hostel>)? best;
  final bool isBool;
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.row, required this.items});
  final _Row row;
  final List<Hostel> items;

  @override
  Widget build(BuildContext context) {
    final String? bestId = row.best?.call(items);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(row.label, style: AppText.caption),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              for (int i = 0; i < items.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(child: _cell(items[i], bestId)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _cell(Hostel h, String? bestId) {
    final String v = row.value(h);
    if (row.isBool) {
      final bool yes = v == 'Yes';
      return Row(
        children: <Widget>[
          Icon(
            yes ? Icons.check_rounded : Icons.close_rounded,
            size: 18,
            color: yes ? AppColors.success : AppColors.danger,
          ),
          const SizedBox(width: 4),
          Text(v, style: AppText.title),
        ],
      );
    }
    final bool best = bestId == h.id;
    return Text(v, style: AppText.title.copyWith(color: best ? AppColors.accent : AppColors.textPrimary));
  }
}
