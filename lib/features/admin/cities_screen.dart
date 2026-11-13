import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

/// Screen 30 — cities, universities and facility tags (admin settings).
class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  int _city = 0;
  final List<String> _cities = List<String>.of(MockData.cities);
  final List<String> _tags = Facilities.all.map((Facility f) => f.label).toList();

  Future<void> _addItem(String title, String hint, ValueChanged<String> onAdd) async {
    final TextEditingController c = TextEditingController();
    final String? value = await showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          autofocus: true,
          style: AppText.body,
          decoration: InputDecoration(hintText: hint, fillColor: AppColors.surfaceHigh),
          onSubmitted: (String v) => Navigator.pop(ctx, v),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Add')),
        ],
      ),
    );
    c.dispose();
    if (value != null && value.trim().isNotEmpty) setState(() => onAdd(value.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DetailAppBar(title: 'Cities and universities'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xl),
        children: <Widget>[
          const FieldLabel('City'),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              for (int i = 0; i < _cities.length; i++)
                SelectPill(label: _cities[i], selected: _city == i, onTap: () => setState(() => _city = i)),
              _AddPill(
                label: 'Add city',
                onTap: () => _addItem('Add city', 'e.g. Rahim Yar Khan', _cities.add),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          FieldLabel(
            'Universities in ${_cities[_city]}',
            trailing: TextButton.icon(
              onPressed: () => showAppSnack(context, 'Add university form', icon: Icons.add),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add'),
            ),
          ),
          if (_city != 0)
            const EmptyState(
              icon: Icons.school_outlined,
              title: 'No universities yet',
              message: 'Add the first campus so students can search near it.',
            )
          else
            for (final University u in MockData.universities)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: SurfaceCard(
                  padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh, borderRadius: AppRadius.mdAll,
                        ),
                        child: Icon(Icons.school_outlined, color: AppColors.accent, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(u.name, style: AppText.title),
                            Text('${u.hostelsNearby} hostels nearby', style: AppText.caption),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit ${u.name}',
                        icon: Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: AppSpacing.lg),
          const FieldLabel('Facility tags'),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              for (final String t in _tags)
                InputChip(
                  label: Text(t),
                  labelStyle: AppText.caption.copyWith(color: AppColors.textPrimary),
                  backgroundColor: AppColors.surface,
                  side: BorderSide(color: AppColors.border),
                  shape: const StadiumBorder(),
                  deleteIconColor: AppColors.textMuted,
                  onDeleted: () => setState(() => _tags.remove(t)),
                ),
              _AddPill(label: 'Add tag', onTap: () => _addItem('Add facility tag', 'e.g. Gym', _tags.add)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddPill extends StatelessWidget {
  const _AddPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: AppColors.accent)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add_rounded, size: 16, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
            ],
          ),
        ),
      ),
    );
  }
}
