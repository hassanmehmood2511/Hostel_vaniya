import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';
import '../../widgets/hostel_cards.dart';
import '../../widgets/scaffolds.dart';

/// Screen 14 — saved hostels with compare selection.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppState.instance;
    return ValueListenableBuilder<Set<String>>(
      valueListenable: state.saved,
      builder: (BuildContext context, Set<String> saved, _) {
        final List<Hostel> hostels =
            MockData.hostels.where((Hostel h) => saved.contains(h.id)).toList();
        return ValueListenableBuilder<Set<String>>(
          valueListenable: state.compare,
          builder: (BuildContext context, Set<String> compare, _) {
            final int n = compare.length;
            return ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              children: <Widget>[
                TabHeader(
                  title: 'Saved hostels',
                  actions: <Widget>[
                    FilledButton.icon(
                      onPressed: n >= 2 ? () => Navigator.pushNamed(context, AppRoutes.compare) : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
                      ),
                      icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                      label: Text('Compare ($n)'),
                    ),
                  ],
                ),
                if (hostels.isEmpty)
                  const EmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: 'No saved hostels yet',
                    message: 'Tap the heart on any hostel to keep it here.',
                  )
                else ...<Widget>[
                  Padding(
                    padding: AppSpacing.screen,
                    child: SurfaceCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.view_column_outlined, color: AppColors.accent),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Select up to ${AppState.maxCompare} hostels to compare rent and '
                              'facilities side by side.',
                              style: AppText.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final Hostel h in hostels)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
                      child: Dismissible(
                        key: ValueKey<String>('saved-${h.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.dangerSoft, borderRadius: AppRadius.lgAll,
                          ),
                          child: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                        ),
                        onDismissed: (_) {
                          state.toggleSaved(h.id);
                          showAppSnack(context, '${h.name} removed', icon: Icons.delete_outline);
                        },
                        child: HostelRowCard(
                          hostel: h,
                          selected: compare.contains(h.id),
                          leading: Checkbox(
                            value: compare.contains(h.id),
                            onChanged: (_) {
                              if (!state.toggleCompare(h.id)) {
                                showAppSnack(
                                  context,
                                  'You can compare up to ${AppState.maxCompare} hostels',
                                  icon: Icons.info_outline,
                                );
                              }
                            },
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(Icons.favorite_rounded, color: AppColors.accent, size: 20),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
