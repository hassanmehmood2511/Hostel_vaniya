import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Selectable pill. Selected = lime fill, unselected = outlined surface.
class SelectPill extends StatelessWidget {
  const SelectPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.dense = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? AppColors.onPrimary : AppColors.textPrimary;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dense ? 12 : 14, vertical: dense ? 7 : 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 15, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: dense ? 12 : 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal, scrollable row of pills.
class PillRow extends StatelessWidget {
  const PillRow({super.key, required this.children, this.padding = AppSpacing.screen});
  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            children[i],
          ],
        ],
      ),
    );
  }
}

enum BadgeTone { success, warning, danger, info, neutral, brand }

/// Small rounded status label (Live, Pending, Accepted …).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.tone, this.icon});

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  (Color, Color) get _colors => switch (tone) {
        BadgeTone.success => (AppColors.successSoft, AppColors.success),
        BadgeTone.warning => (AppColors.warningSoft, AppColors.warning),
        BadgeTone.danger => (AppColors.dangerSoft, AppColors.danger),
        BadgeTone.info => (AppColors.infoSoft, AppColors.info),
        BadgeTone.neutral => (AppColors.surfaceHigher, AppColors.textSecondary),
        BadgeTone.brand => (AppColors.primary, AppColors.onPrimary),
      };

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.smAll),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg, height: 1.1),
          ),
        ],
      ),
    );
  }
}

/// Lime "Verified" pill with a shield check.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusBadge(
      label: 'Verified', tone: BadgeTone.brand, icon: Icons.verified_user_rounded,
    );
  }
}

/// Muted tag on dark surfaces ("Boys", "Boys hostel").
class TagLabel extends StatelessWidget {
  const TagLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.75),
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Facility chip with icon used in "Included in rent" lists.
class FacilityChip extends StatelessWidget {
  const FacilityChip({super.key, required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
