import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

/// Screen 28 — users (students and owners).
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int _tab = 0;
  String _query = '';
  final Map<String, bool> _blocked = <String, bool>{};

  bool _isBlocked(AppUser u) => _blocked[u.name] ?? u.blocked;

  Future<void> _toggle(AppUser u) async {
    final bool blocking = !_isBlocked(u);
    if (blocking) {
      final bool ok = await confirmAction(
        context,
        title: 'Block ${u.name}?',
        message: 'They won\'t be able to log in, contact owners or post reviews.',
        confirmLabel: 'Block',
        destructive: true,
      );
      if (!ok || !mounted) return;
    }
    setState(() => _blocked[u.name] = blocking);
    if (mounted) showAppSnack(context, blocking ? '${u.name} blocked' : '${u.name} unblocked');
  }

  @override
  Widget build(BuildContext context) {
    final String q = _query.toLowerCase().replaceAll(' ', '');
    final List<AppUser> source = _tab == 0 ? MockData.students : MockData.owners;
    final List<AppUser> list = source
        .where((AppUser u) => q.isEmpty ||
            u.name.toLowerCase().replaceAll(' ', '').contains(q) ||
            u.phone.replaceAll(' ', '').contains(q))
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'Users'),
        Padding(
          padding: AppSpacing.screen,
          child: SegmentedTabs(
            labels: const <String>['Students · 3,420', 'Owners · 186'],
            selected: _tab,
            onChanged: (int i) => setState(() => _tab = i),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: AppSpacing.screen,
          child: TextField(
            onChanged: (String v) => setState(() => _query = v),
            style: AppText.body,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Search name or phone',
              prefixIcon: Icon(Icons.search_rounded, size: 20),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (list.isEmpty)
          const EmptyState(icon: Icons.person_search_outlined, title: 'No users found', message: 'Check the spelling or number.'),
        for (final AppUser u in list)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs),
            child: SurfaceCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  InitialsAvatar(name: u.name),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(u.name, style: AppText.title, overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 6),
                            _isBlocked(u)
                                ? const StatusBadge(label: 'Blocked', tone: BadgeTone.danger)
                                : const StatusBadge(label: 'Active', tone: BadgeTone.success),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('${u.phone} · ${u.institute}', style: AppText.caption),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _isBlocked(u)
                      ? AppButton(
                          label: 'Unblock', compact: true, expand: false,
                          variant: AppButtonVariant.secondary, onPressed: () => _toggle(u),
                        )
                      : AppButton(
                          label: 'Block', compact: true, expand: false,
                          variant: AppButtonVariant.danger, onPressed: () => _toggle(u),
                        ),
                ],
              ),
            ),
          ),
        if (list.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Center(
              child: Text(
                'Showing ${list.length} of ${_tab == 0 ? '3,420' : '186'}',
                style: AppText.caption.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
      ],
    );
  }
}
