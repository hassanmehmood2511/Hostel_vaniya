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

/// Screen 29 — student/owner reports.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _tab = 0;
  final Set<String> _resolved = <String>{};

  void _resolve(ListingReport r, String message) {
    setState(() => _resolved.add(r.subject));
    showAppSnack(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final List<ListingReport> open =
        MockData.reports.where((ListingReport r) => !_resolved.contains(r.subject)).toList();
    final List<ListingReport> done =
        MockData.reports.where((ListingReport r) => _resolved.contains(r.subject)).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'Reports'),
        Padding(
          padding: AppSpacing.screen,
          child: SegmentedTabs(
            labels: <String>['Open · ${open.length + 2}', 'Resolved · ${41 + done.length}'],
            selected: _tab,
            onChanged: (int i) => setState(() => _tab = i),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_tab == 1 && done.isEmpty)
          const EmptyState(
            icon: Icons.task_alt_rounded,
            title: 'Resolved reports',
            message: 'Reports you act on this session will appear here.',
          ),
        for (final ListingReport r in _tab == 0 ? open : done)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: _ReportCard(report: r, resolved: _tab == 1, onResolve: _resolve),
          ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report, required this.resolved, required this.onResolve});
  final ListingReport report;
  final bool resolved;
  final void Function(ListingReport, String) onResolve;

  BadgeTone get _tone => switch (report.severity) {
        ReportSeverity.high => BadgeTone.danger,
        ReportSeverity.medium => BadgeTone.warning,
        ReportSeverity.low => BadgeTone.info,
      };

  @override
  Widget build(BuildContext context) {
    final bool isReview = report.kind == 'Abusive review';
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              StatusBadge(label: report.kind, tone: _tone),
              const Spacer(),
              Text(report.reporter, style: AppText.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(report.subject, style: AppText.h3),
          const SizedBox(height: 4),
          Text(report.detail, style: AppText.bodySecondary),
          if (!resolved) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            if (isReview)
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      label: 'Keep', compact: true, variant: AppButtonVariant.secondary,
                      onPressed: () => onResolve(report, 'Review kept'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: AppButton(
                      label: 'Remove review', compact: true,
                      variant: AppButtonVariant.danger,
                      onPressed: () => onResolve(report, 'Review removed'),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      label: 'Dismiss', compact: true, variant: AppButtonVariant.secondary,
                      onPressed: () => onResolve(report, 'Report dismissed'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: AppButton(
                      label: 'View', compact: true, variant: AppButtonVariant.secondary,
                      onPressed: () => showAppSnack(context, 'Opening ${report.subject}', icon: Icons.open_in_new),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: AppButton(
                      label: 'Suspend', compact: true,
                      variant: AppButtonVariant.danger,
                      onPressed: () async {
                        final bool ok = await confirmAction(
                          context,
                          title: 'Suspend ${report.subject}?',
                          message: 'The listing will be hidden from students until you restore it.',
                          confirmLabel: 'Suspend',
                          destructive: true,
                        );
                        if (ok) onResolve(report, '${report.subject} suspended');
                      },
                    ),
                  ),
                ],
              ),
          ] else ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 6),
                Text('Resolved', style: AppText.caption),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
