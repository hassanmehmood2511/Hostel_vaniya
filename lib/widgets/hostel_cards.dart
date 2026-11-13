import 'package:flutter/material.dart';

import '../core/routing/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/formatters.dart';
import '../data/app_state.dart';
import '../data/models.dart';
import 'chips_badges.dart';
import 'common.dart';

/// Heart toggle bound to [AppState.saved].
class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.hostelId, this.size = 34, this.filledStyle = false});
  final String hostelId;
  final double size;

  /// When true renders as a lime square (detail header).
  final bool filledStyle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: AppState.instance.saved,
      builder: (BuildContext context, Set<String> saved, _) {
        final bool isSaved = saved.contains(hostelId);
        return Tooltip(
          message: isSaved ? 'Remove from saved' : 'Save hostel',
          child: Material(
            color: filledStyle && isSaved
                ? AppColors.primary
                : AppColors.background.withValues(alpha: 0.8),
            shape: filledStyle
                ? const RoundedRectangleBorder(borderRadius: AppRadius.mdAll)
                : const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                AppState.instance.toggleSaved(hostelId);
                showAppSnack(
                  context,
                  isSaved ? 'Removed from saved hostels' : 'Saved. Find it in the Saved tab.',
                  icon: isSaved ? Icons.favorite_border : Icons.favorite,
                );
              },
              child: SizedBox(
                width: size,
                height: size,
                child: Icon(
                  isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: size * 0.52,
                  color: filledStyle && isSaved
                      ? AppColors.onPrimary
                      : (isSaved ? AppColors.accent : AppColors.textPrimary),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// `Rs 12,000 /month`
class PriceText extends StatelessWidget {
  const PriceText({super.key, required this.amount, this.suffix = '/month', this.size = 16});
  final int amount;
  final String suffix;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: Fmt.rs(amount), style: AppText.price.copyWith(fontSize: size)),
          TextSpan(text: ' $suffix', style: AppText.caption),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Small icon list for the top facilities.
class FacilityIcons extends StatelessWidget {
  const FacilityIcons({super.key, required this.facilities, this.max = 3});
  final List<Facility> facilities;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final Facility f in facilities.take(max))
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Tooltip(
              message: f.label,
              child: Icon(f.icon, size: 16, color: AppColors.textSecondary),
            ),
          ),
      ],
    );
  }
}

/// Vertical card used in the "Near your campus" carousel.
class HostelCarouselCard extends StatelessWidget {
  const HostelCarouselCard({super.key, required this.hostel, this.width = 220});
  final Hostel hostel;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: SurfaceCard(
        padding: const EdgeInsets.all(10),
        onTap: () => Navigator.pushNamed(context, AppRoutes.hostelDetail, arguments: hostel.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 120,
              child: Stack(
                children: <Widget>[
                  const Positioned.fill(child: PhotoPlaceholder()),
                  if (hostel.verified) const Positioned(top: 8, left: 8, child: VerifiedBadge()),
                  Positioned(top: 6, right: 6, child: SaveButton(hostelId: hostel.id, size: 30)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(hostel.name, style: AppText.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Row(
              children: <Widget>[
                Icon(Icons.place_outlined, size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 3),
                Text('${Fmt.km(hostel.distanceKm)} · ${hostel.type.label}', style: AppText.caption),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(child: PriceText(amount: hostel.startingRent, size: 15)),
                RatingPill(rating: hostel.rating),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Large list card used in search results.
class HostelListCard extends StatelessWidget {
  const HostelListCard({super.key, required this.hostel});
  final Hostel hostel;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(10),
      onTap: () => Navigator.pushNamed(context, AppRoutes.hostelDetail, arguments: hostel.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 8,
            child: Stack(
              children: <Widget>[
                const Positioned.fill(child: PhotoPlaceholder()),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    children: <Widget>[
                      if (hostel.verified) ...<Widget>[
                        const VerifiedBadge(),
                        const SizedBox(width: 6),
                      ],
                      TagLabel(hostel.type.label),
                    ],
                  ),
                ),
                Positioned(top: 6, right: 6, child: SaveButton(hostelId: hostel.id)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        hostel.name, style: AppText.h3, maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    RatingPill(rating: hostel.rating),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 3),
                    Text('${Fmt.km(hostel.distanceKm)} · ${hostel.area}', style: AppText.caption),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    FacilityIcons(facilities: hostel.facilities),
                    const Spacer(),
                    PriceText(amount: hostel.startingRent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact horizontal card (top rated, saved list, map preview).
class HostelRowCard extends StatelessWidget {
  const HostelRowCard({
    super.key,
    required this.hostel,
    this.leading,
    this.trailing,
    this.selected = false,
    this.subtitle,
    this.onTap,
  });

  final Hostel hostel;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(10),
      borderColor: selected ? AppColors.accent : null,
      onTap: onTap ??
          () => Navigator.pushNamed(context, AppRoutes.hostelDetail, arguments: hostel.id),
      child: Row(
        children: <Widget>[
          if (leading != null) ...<Widget>[leading!, const SizedBox(width: 10)],
          const SizedBox(
            width: 72,
            height: 72,
            child: PhotoPlaceholder(showLabel: false, iconSize: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(hostel.name, style: AppText.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(
                  subtitle ??
                      '${hostel.type.label} · ${Fmt.km(hostel.distanceKm)} · '
                          '${hostel.rating.toStringAsFixed(1)} ★',
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                PriceText(amount: hostel.startingRent, suffix: '/mo', size: 14),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
