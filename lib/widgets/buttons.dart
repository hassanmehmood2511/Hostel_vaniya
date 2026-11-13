import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outlinePrimary, whatsapp, danger }

/// Full-width (by default) button with the app's sizing and an optional icon.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = AppButtonVariant.primary,
    this.expand = true,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final AppButtonVariant variant;
  final bool expand;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double height = compact ? 40 : 52;
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: compact ? 17 : 19),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        if (trailingIcon != null) ...<Widget>[
          const SizedBox(width: AppSpacing.xs),
          Icon(trailingIcon, size: compact ? 17 : 19),
        ],
      ],
    );

    final TextStyle? textStyle = compact
        ? const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)
        : null;
    final Size minSize = Size(expand ? double.infinity : 0, height);
    final EdgeInsets padding = EdgeInsets.symmetric(horizontal: compact ? 12 : 16);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: minSize, padding: padding, textStyle: textStyle,
          ),
          child: content,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: minSize, padding: padding, textStyle: textStyle,
          ),
          child: content,
        ),
      AppButtonVariant.outlinePrimary => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: minSize,
            padding: padding,
            textStyle: textStyle,
            foregroundColor: AppColors.accent,
            backgroundColor: Colors.transparent,
            side: BorderSide(color: AppColors.accent, width: 1.2),
          ),
          child: content,
        ),
      AppButtonVariant.whatsapp => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: minSize,
            padding: padding,
            textStyle: textStyle,
            foregroundColor: AppColors.whatsapp,
            backgroundColor: Colors.transparent,
            side: BorderSide(color: AppColors.whatsapp, width: 1.2),
          ),
          child: content,
        ),
      AppButtonVariant.danger => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: minSize,
            padding: padding,
            textStyle: textStyle,
            backgroundColor: AppColors.dangerSoft,
            foregroundColor: AppColors.danger,
          ),
          child: content,
        ),
    };

    return SizedBox(height: height, width: expand ? double.infinity : null, child: button);
  }
}

/// Rounded-square icon button used for back, share, settings etc.
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.highlighted = false,
    this.size = 40,
    this.badge = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool highlighted;
  final double size;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: highlighted ? AppColors.primary : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: highlighted ? BorderSide.none : BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 20,
                  color: highlighted ? AppColors.onPrimary : AppColors.textPrimary,
                ),
                if (badge)
                  Positioned(
                    top: 9,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 1.5),
                      ),
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

/// Back button matching the design (rounded square, left chevron).
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SquareIconButton(
      icon: Icons.chevron_left_rounded,
      tooltip: 'Back',
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}

/// Small circular accept/decline style action.
class RoundActionButton extends StatelessWidget {
  const RoundActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.background,
    this.foreground,
    this.size = 40,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? background;
  final Color? foreground;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background ?? AppColors.surfaceHigh,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: 19, color: foreground ?? AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
