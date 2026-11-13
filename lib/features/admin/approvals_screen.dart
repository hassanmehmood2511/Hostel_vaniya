import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

class _Pending {
  const _Pending(this.name, this.meta, this.ago);
  final String name;
  final String meta;
  final String ago;
}

/// Screen 26 — admin approvals queue.
class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  int _tab = 0;
  bool _featuredHandled = false;

  static const List<_Pending> _queue = <_Pending>[
    _Pending('Fatima Girls Hostel', 'Girls · Satellite Town', '5 hours ago'),
    _Pending('Rohi Boys Hostel', 'Boys · Baghdad Road', '1 day ago'),
    _Pending('Sadiq Residency', 'Boys · Model Town C', '1 day ago'),
  ];

  static const List<_Pending> _edits = <_Pending>[
    _Pending('Iqra Girls Hostel', 'Changed rent · 2-seater', '3 hours ago'),
    _Pending('Cholistan Residency', 'Added 4 photos', '6 hours ago'),
  ];

  Future<void> _decide(bool approve) async {
    if (!approve) {
      final bool ok = await confirmAction(
        context,
        title: 'Reject Al-Noor Annex?',
        message: 'The owner will be asked to upload the missing rent agreement and resubmit.',
        confirmLabel: 'Reject',
        destructive: true,
      );
      if (!ok || !mounted) return;
    }
    setState(() => _featuredHandled = true);
    if (mounted) {
      showAppSnack(
        context,
        approve ? 'Al-Noor Annex is now live' : 'Listing rejected — owner notified',
        icon: approve ? Icons.check_circle : Icons.close,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_Pending> rest = _tab == 0 ? _queue : _edits;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'Approvals'),
        Padding(
          padding: AppSpacing.screen,
          child: SegmentedTabs(
            labels: const <String>['New listings · 8', 'Edits · 4'],
            selected: _tab,
            onChanged: (int i) => setState(() => _tab = i),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_tab == 0 && !_featuredHandled)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            child: SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 76,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
                        SizedBox(width: 6),
                        Expanded(child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
                        SizedBox(width: 6),
                        Expanded(child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: <Widget>[
                      Expanded(child: Text(MockData.alNoorAnnex.name, style: AppText.h3)),
                      Text('2 hours ago', style: AppText.caption),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Boys · ${MockData.alNoorAnnex.area} · Owner: ${MockData.alNoorAnnex.owner}',
                    style: AppText.caption,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: 6,
                    children: <Widget>[
                      _Check(label: '8 photos', ok: true),
                      _Check(label: 'Map pin set', ok: true),
                      _Check(label: 'CNIC uploaded', ok: true),
                      _Check(label: 'Rent agreement missing', ok: false),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppButton(
                          label: 'Reject', compact: true, variant: AppButtonVariant.danger,
                          onPressed: () => _decide(false),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: AppButton(
                          label: 'View', compact: true, variant: AppButtonVariant.secondary,
                          onPressed: () => Navigator.pushNamed(
                            context, AppRoutes.hostelDetail, arguments: MockData.alNoorAnnex.id,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: AppButton(label: 'Approve', compact: true, onPressed: () => _decide(true)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        for (final _Pending p in rest)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: SurfaceCard(
              padding: const EdgeInsets.all(12),
              onTap: () => showAppSnack(context, 'Opening ${p.name} for review', icon: Icons.open_in_new),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 52, height: 52, child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(p.name, style: AppText.title),
                        Text('${p.meta} · ${p.ago}', style: AppText.caption),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.label, required this.ok});
  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
          size: 16,
          color: ok ? AppColors.success : AppColors.warning,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppText.caption.copyWith(color: ok ? AppColors.textSecondary : AppColors.warning),
        ),
      ],
    );
  }
}
