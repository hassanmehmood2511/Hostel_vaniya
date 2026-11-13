import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/hostel_cards.dart';

/// Screen 6 — student home.
class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  static const List<String> _quickFilters = <String>[
    'All', 'Boys', 'Girls', 'Under Rs 10k', 'Meals included',
  ];
  int _filter = 0;

  List<Hostel> get _nearby {
    final List<Hostel> list = MockData.hostels.where((Hostel h) {
      return switch (_filter) {
        1 => h.type == HostelType.boys,
        2 => h.type == HostelType.girls,
        3 => h.startingRent < 10000,
        4 => h.meals > 0,
        _ => true,
      };
    }).toList()
      ..sort((Hostel a, Hostel b) => a.distanceKm.compareTo(b.distanceKm));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final List<Hostel> nearby = _nearby;
    final List<Hostel> topRated = List<Hostel>.of(MockData.hostels)
      ..sort((Hostel a, Hostel b) => b.rating.compareTo(a.rating));

    return RefreshIndicator(
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      onRefresh: () => Future<void>.delayed(const Duration(milliseconds: 700)),
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: <Widget>[
          // Greeting + campus selector
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Hi, ${MockData.studentFirstName}', style: AppText.caption),
                      const SizedBox(height: 2),
                      InkWell(
                        borderRadius: AppRadius.smAll,
                        onTap: () => _pickCampus(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.place_rounded, size: 18, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Text(MockData.campus, style: AppText.h3),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SquareIconButton(
                  icon: Icons.notifications_none_rounded,
                  tooltip: 'Notifications',
                  badge: true,
                  onPressed: () => showAppSnack(
                    context, 'Al-Noor accepted your visit for Sat 4:00 PM',
                    icon: Icons.notifications_active_outlined,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Search
          Padding(
            padding: AppSpacing.screen,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Material(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdAll,
                      side: BorderSide(color: AppColors.border),
                    ),
                    child: InkWell(
                      borderRadius: AppRadius.mdAll,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.results),
                      child: SizedBox(
                        height: 48,
                        child: Row(
                          children: <Widget>[
                            const SizedBox(width: 14),
                            Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                            const SizedBox(width: 10),
                            Text('Search hostel or area', style: TextStyle(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                SquareIconButton(
                  icon: Icons.tune_rounded,
                  tooltip: 'Filters',
                  highlighted: true,
                  size: 48,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.filters),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PillRow(
            children: <Widget>[
              for (int i = 0; i < _quickFilters.length; i++)
                SelectPill(
                  label: _quickFilters[i],
                  selected: _filter == i,
                  onTap: () => setState(() => _filter = i),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: 'Near your campus',
            action: 'See all',
            onAction: () => Navigator.pushNamed(context, AppRoutes.results),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: 250,
            child: nearby.isEmpty
                ? Center(child: Text('No hostels match this filter', style: AppText.bodySecondary))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: AppSpacing.screen,
                    itemCount: nearby.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int i) => HostelCarouselCard(hostel: nearby[i]),
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: 'Top rated this month',
            action: 'See all',
            onAction: () => Navigator.pushNamed(context, AppRoutes.results),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final Hostel h in topRated.take(3))
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
              child: HostelRowCard(
                hostel: h,
                subtitle: '${h.type.label} · ${h.distanceKm} km · '
                    '${h.meals > 0 ? 'Meals included' : 'No meals'}',
                trailing: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: RatingPill(rating: h.rating),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _pickCampus(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs),
              child: Text('Choose campus', style: AppText.h3),
            ),
            for (final University u in MockData.universities)
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(u.name, style: AppText.title),
                subtitle: Text('${u.hostelsNearby} hostels nearby', style: AppText.caption),
                trailing: u.name.startsWith('IUB, Baghdad')
                    ? Icon(Icons.check_circle_rounded, color: AppColors.accent)
                    : null,
                onTap: () => Navigator.pop(ctx),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
