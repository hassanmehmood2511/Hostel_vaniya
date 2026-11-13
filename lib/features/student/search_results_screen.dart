import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/hostel_cards.dart';
import '../../widgets/scaffolds.dart';

enum _Sort { nearest, cheapest, rating }

/// Screen 7 — search results list.
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  _Sort _sort = _Sort.nearest;
  bool _boysOnly = true;
  bool _wifi = false;

  String get _sortLabel => switch (_sort) {
        _Sort.nearest => 'Nearest first',
        _Sort.cheapest => 'Lowest rent',
        _Sort.rating => 'Highest rated',
      };

  List<Hostel> get _results {
    final List<Hostel> list = MockData.hostels
        .where((Hostel h) => !_boysOnly || h.type == HostelType.boys)
        .where((Hostel h) => !_wifi || h.facilities.any((Facility f) => f.label == 'Wi-Fi'))
        .toList();
    switch (_sort) {
      case _Sort.nearest:
        list.sort((Hostel a, Hostel b) => a.distanceKm.compareTo(b.distanceKm));
      case _Sort.cheapest:
        list.sort((Hostel a, Hostel b) => a.startingRent.compareTo(b.startingRent));
      case _Sort.rating:
        list.sort((Hostel a, Hostel b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final List<Hostel> results = _results;
    return Scaffold(
      appBar: DetailAppBar(
        title: 'Hostels near IUB',
        actions: <Widget>[
          SquareIconButton(
            icon: Icons.map_outlined,
            tooltip: 'Map view',
            onPressed: () {
              AppState.instance.studentTab.value = 1;
              Navigator.popUntil(
                context,
                (Route<dynamic> r) => r.settings.name == AppRoutes.student || r.isFirst,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.xs, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('${results.length} hostels found', style: AppText.bodySecondary),
                ),
                PopupMenuButton<_Sort>(
                  initialValue: _sort,
                  color: AppColors.surfaceHigh,
                  tooltip: 'Sort',
                  onSelected: (_Sort s) => setState(() => _sort = s),
                  itemBuilder: (_) => const <PopupMenuEntry<_Sort>>[
                    PopupMenuItem<_Sort>(value: _Sort.nearest, child: Text('Nearest first')),
                    PopupMenuItem<_Sort>(value: _Sort.cheapest, child: Text('Lowest rent')),
                    PopupMenuItem<_Sort>(value: _Sort.rating, child: Text('Highest rated')),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.swap_vert_rounded, size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(_sortLabel, style: AppText.label.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          PillRow(
            children: <Widget>[
              SelectPill(
                label: 'Filters · 2',
                icon: Icons.tune_rounded,
                selected: true,
                onTap: () => Navigator.pushNamed(context, AppRoutes.filters),
              ),
              SelectPill(
                label: 'Boys', selected: _boysOnly, onTap: () => setState(() => _boysOnly = !_boysOnly),
              ),
              SelectPill(label: 'Rs 8k–15k', selected: false, onTap: () {}),
              SelectPill(label: 'Wi-Fi', selected: _wifi, onTap: () => setState(() => _wifi = !_wifi)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: results.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No hostels match',
                    message: 'Try removing a filter or increasing the distance.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int i) => HostelListCard(hostel: results[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
