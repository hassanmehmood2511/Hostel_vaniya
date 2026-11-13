import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/formatters.dart';

/// Rounded surface container used for cards and grouped content.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.color,
    this.borderColor,
    this.radius = AppRadius.lgAll,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        // Light mode gets a hairline border so white cards separate from the page.
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 1.2)
            : (AppColors.isDark ? BorderSide.none : BorderSide(color: AppColors.border)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Placeholder for hostel photos until real images are wired in.
class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    super.key,
    this.label = 'Hostel photo',
    this.radius = AppRadius.mdAll,
    this.showLabel = true,
    this.iconSize = 22,
  });

  final String label;
  final BorderRadius radius;
  final bool showLabel;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[AppColors.photoStart, AppColors.photoEnd],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.image_outlined, size: iconSize, color: AppColors.textMuted),
              if (showLabel) ...<Widget>[
                const SizedBox(height: 4),
                Text(label, style: AppText.caption.copyWith(color: AppColors.textMuted)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Circle avatar with initials.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.size = 40, this.highlight = false});
  final String name;
  final double size;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: highlight ? AppColors.primarySoft : AppColors.surfaceHigher,
        border: highlight ? Border.all(color: AppColors.accent, width: 1.5) : null,
      ),
      child: Text(
        Fmt.initials(name),
        style: TextStyle(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
          color: highlight ? AppColors.accent : AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// `★ 4.6` compact rating.
class RatingPill extends StatelessWidget {
  const RatingPill({super.key, required this.rating, this.count});
  final double rating;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.star_rounded, size: 16, color: AppColors.star),
        const SizedBox(width: 3),
        Text(
          count == null ? rating.toStringAsFixed(1) : '${rating.toStringAsFixed(1)} ($count)',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class StarRow extends StatelessWidget {
  const StarRow({super.key, required this.rating, this.size = 14});
  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$rating out of 5 stars',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          5,
          (int i) => Icon(
            Icons.star_rounded,
            size: size,
            color: i < rating ? AppColors.star : AppColors.surfaceHigher,
          ),
        ),
      ),
    );
  }
}

/// `Near your campus ............ See all`
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction, this.trailing});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screen,
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title, style: AppText.h3)),
          if (trailing != null) trailing!,
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(44, 36),
              ),
              child: Text(action!),
            ),
        ],
      ),
    );
  }
}

/// Small label above form fields and grouped settings.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(text, style: AppText.label)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Label + text field pair.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.keyboardType,
    this.obscure = false,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.controller,
  });

  final String label;
  final String? hint;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool obscure;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FieldLabel(label),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          keyboardType: keyboardType,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          validator: validator,
          textInputAction: textInputAction,
          style: AppText.body,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

/// Password field with show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.label, this.initialValue, this.validator});
  final String label;
  final String? initialValue;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: widget.label,
      hint: 'Enter password',
      initialValue: widget.initialValue,
      obscure: _hidden,
      validator: widget.validator,
      textInputAction: TextInputAction.done,
      suffix: IconButton(
        tooltip: _hidden ? 'Show password' : 'Hide password',
        icon: Icon(_hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
        onPressed: () => setState(() => _hidden = !_hidden),
      ),
    );
  }
}

/// Two-option segmented control (Boys | Girls, Students | Owners …).
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.mdAll),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                selected: i == selected,
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? AppColors.surfaceHigher : Colors.transparent,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Text(
                      labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: i == selected ? FontWeight.w700 : FontWeight.w500,
                        color: i == selected ? AppColors.accent : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// KPI tile used on owner and admin dashboards.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.delta,
    this.deltaColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? delta;
  final Color? deltaColor;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(label, style: AppText.caption)),
              Icon(icon, size: 18, color: AppColors.accent),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppText.stat),
          if (delta != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              delta!,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: deltaColor ?? AppColors.success),
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple 7-day bar chart; highlights the highest bar.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key, required this.values, this.height = 120});
  final List<int> values;
  final double height;

  static const List<String> _days = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final int maxV = values.reduce((int a, int b) => a > b ? a : b);
    final int maxIndex = values.indexOf(maxV);
    return Semantics(
      label: 'Bar chart for the last 7 days. Highest: $maxV on day ${maxIndex + 1}.',
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            for (int i = 0; i < values.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (i == maxIndex)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '$maxV',
                            style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.accent,
                            ),
                          ),
                        ),
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: (values[i] / maxV).clamp(0.08, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: i == maxIndex ? AppColors.accent : AppColors.surfaceHigher,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_days[i], style: AppText.caption.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Settings row: icon, title, optional value/switch, chevron.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final Color color = destructive ? AppColors.danger : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: destructive ? AppColors.dangerSoft : AppColors.surfaceHigh,
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(icon, size: 18, color: destructive ? AppColors.danger : AppColors.accent),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppText.title.copyWith(color: color)),
                  if (subtitle != null) Text(subtitle!, style: AppText.caption),
                ],
              ),
            ),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(value!, style: AppText.caption),
              ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: destructive ? AppColors.danger : AppColors.textMuted,
                ),
          ],
        ),
      ),
    );
  }
}

/// Sticky bottom container for primary actions.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
        child: child,
      ),
    );
  }
}

/// Key–value row (Curfew …… 10:30 PM).
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value, this.icon, this.valueColor});
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(child: Text(label, style: AppText.bodySecondary)),
          Text(
            value,
            style: AppText.title.copyWith(color: valueColor ?? AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Empty-state block for lists with no items.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: 48),
      child: Column(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.accent, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppText.h3, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(message, style: AppText.bodySecondary, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// App mark used on the welcome screen and splash.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.apartment_rounded, size: size * 0.52, color: AppColors.onPrimary),
    );
  }
}

/// "Hostel**Vaniya**" wordmark.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.fontSize = 28});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        children: <InlineSpan>[
          TextSpan(text: 'Hostel', style: TextStyle(color: AppColors.textPrimary)),
          TextSpan(text: 'Vaniya', style: TextStyle(color: AppColors.accent)),
        ],
      ),
    );
  }
}

/// Snackbar helper for UI-only actions.
void showAppSnack(BuildContext context, String message, {IconData icon = Icons.check_circle}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}

/// Confirmation dialog; returns true when confirmed.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(
            foregroundColor: destructive ? AppColors.danger : AppColors.accent,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
