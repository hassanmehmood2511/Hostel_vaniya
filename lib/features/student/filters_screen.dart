import 'package:flutter/material.dart';

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

/// Screen 8 — filters (full-screen sheet).
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const RangeValues _defaultRent = RangeValues(6000, 18000);
  static const List<String> _roomTypes = <String>['Single', '2-seater', '3-seater', 'Dorm'];
  static const List<String> _distances = <String>['Under 1 km', 'Under 3 km', 'Under 5 km'];

  int _type = 0;
  RangeValues _rent = _defaultRent;
  final Set<String> _rooms = <String>{'2-seater'};
  int _distance = 0;
  final Set<String> _facilities = <String>{'Wi-Fi', 'Meals'};
  bool _verifiedOnly = true;

  int get _matchCount {
    // Illustrative count that reacts to the controls.
    int c = 48;
    c -= (_rent.start - 3000) ~/ 1000;
    c -= (25000 - _rent.end) ~/ 1500;
    c -= _facilities.length * 3 + _distance * -4 + (_verifiedOnly ? 6 : 0);
    return c.clamp(1, 48);
  }

  void _reset() => setState(() {
        _type = 0;
        _rent = _defaultRent;
        _rooms
          ..clear()
          ..add('2-seater');
        _distance = 0;
        _facilities.clear();
        _verifiedOnly = false;
      });

  Widget _section(String title, Widget child, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FieldLabel(title, trailing: trailing),
            const SizedBox(height: 4),
            child,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DetailAppBar(title: 'Filters'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xl),
        children: <Widget>[
          _section(
            'Hostel type',
            SegmentedTabs(
              labels: const <String>['Boys', 'Girls'],
              selected: _type,
              onChanged: (int i) => setState(() => _type = i),
            ),
          ),
          _section(
            'Monthly rent',
            RangeSlider(
              values: _rent,
              min: 3000,
              max: 25000,
              divisions: 44,
              labels: RangeLabels(Fmt.rs(_rent.start.round()), Fmt.rs(_rent.end.round())),
              onChanged: (RangeValues v) => setState(() => _rent = v),
            ),
            trailing: Text(
              '${Fmt.rs(_rent.start.round())} – ${Fmt.rs(_rent.end.round())}',
              style: AppText.label.copyWith(color: AppColors.textPrimary),
            ),
          ),
          _section(
            'Room type',
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final String r in _roomTypes)
                  SelectPill(
                    label: r,
                    selected: _rooms.contains(r),
                    onTap: () => setState(() => _rooms.contains(r) ? _rooms.remove(r) : _rooms.add(r)),
                  ),
              ],
            ),
          ),
          _section(
            'Distance from campus',
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (int i = 0; i < _distances.length; i++)
                  SelectPill(
                    label: _distances[i],
                    selected: _distance == i,
                    onTap: () => setState(() => _distance = i),
                  ),
              ],
            ),
          ),
          _section(
            'Facilities',
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final Facility f in Facilities.all)
                  SelectPill(
                    label: f.label,
                    icon: f.icon,
                    selected: _facilities.contains(f.label),
                    onTap: () => setState(
                      () => _facilities.contains(f.label)
                          ? _facilities.remove(f.label)
                          : _facilities.add(f.label),
                    ),
                  ),
              ],
            ),
          ),
          SurfaceCard(
            onTap: () => setState(() => _verifiedOnly = !_verifiedOnly),
            child: Row(
              children: <Widget>[
                Icon(Icons.verified_user_outlined, color: AppColors.accent),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Verified only', style: AppText.title),
                      Text('Documents checked by admin', style: AppText.caption),
                    ],
                  ),
                ),
                Switch(value: _verifiedOnly, onChanged: (bool v) => setState(() => _verifiedOnly = v)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Row(
          children: <Widget>[
            AppButton(
              label: 'Reset', expand: false, variant: AppButtonVariant.secondary, onPressed: _reset,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: 'Show $_matchCount hostels',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
