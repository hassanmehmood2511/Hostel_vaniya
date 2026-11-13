import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

class _DocStep {
  _DocStep(this.title, this.hint, {this.done = false});
  final String title;
  final String hint;
  bool done;
}

/// Screen 23 — owner verification documents.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<_DocStep> _steps = <_DocStep>[
    _DocStep('CNIC (front and back)', 'Owner\'s national ID', done: true),
    _DocStep('Hostel photos', 'At least 5 clear photos · 8 added', done: true),
    _DocStep('Ownership or rent agreement', 'PDF or photo'),
    _DocStep('Recent utility bill', 'Electricity or gas bill'),
  ];

  int get _done => _steps.where((_DocStep s) => s.done).length;

  @override
  Widget build(BuildContext context) {
    final bool complete = _done == _steps.length;
    return Scaffold(
      appBar: const DetailAppBar(title: 'Verification'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xl),
        children: <Widget>[
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.mdAll),
                  child: Icon(Icons.verified_user_rounded, color: AppColors.onPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Get the Verified badge', style: AppText.h2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Verified hostels rank higher in search and students trust them more. '
                  'Admin checks your documents within 48 hours.',
                  style: AppText.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: AppRadius.pillAll,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: _done / _steps.length),
                    duration: const Duration(milliseconds: 300),
                    builder: (_, double v, __) => LinearProgressIndicator(value: v, minHeight: 6),
                  ),
                ),
                const SizedBox(height: 6),
                Text('$_done of ${_steps.length} steps done', style: AppText.caption),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (int i = 0; i < _steps.length; i++) ...<Widget>[
            SurfaceCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _steps[i].done ? AppColors.successSoft : AppColors.surfaceHigh,
                    ),
                    child: _steps[i].done
                        ? Icon(Icons.check_rounded, size: 18, color: AppColors.success)
                        : Text('${i + 1}', style: AppText.title),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_steps[i].title, style: AppText.title),
                        Text(_steps[i].hint, style: AppText.caption),
                      ],
                    ),
                  ),
                  if (_steps[i].done)
                    const StatusBadge(label: 'Uploaded', tone: BadgeTone.success, icon: Icons.check_rounded)
                  else
                    AppButton(
                      label: 'Upload',
                      icon: Icons.upload_rounded,
                      compact: true,
                      expand: false,
                      onPressed: () => setState(() => _steps[i].done = true),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Documents are only seen by the admin team and never shown to students.',
                  style: AppText.caption,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: AppButton(
          label: 'Submit for verification',
          onPressed: complete
              ? () {
                  Navigator.pop(context);
                  showAppSnack(context, 'Submitted. We\'ll notify you within 48 hours.');
                }
              : null,
        ),
      ),
    );
  }
}
