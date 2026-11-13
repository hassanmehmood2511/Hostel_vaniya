import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';
import '../../widgets/hostel_cards.dart';

/// Screen 9 — map view with rent pins.
///
/// The map is an illustrative canvas so the UI works without API keys.
/// Swap [_MapCanvas] for `google_maps_flutter` and keep the overlays.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Hostel _selected = MockData.alNoor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints c) {
              final Size size = Size(c.maxWidth, c.maxHeight - 120);
              return Stack(
                children: <Widget>[
                  Positioned.fill(child: CustomPaint(painter: _MapCanvas(AppColors.palette))),
                  // Campus marker
                  Positioned(
                    left: size.width * 0.47 - 28,
                    top: size.height * 0.40 - 28,
                    child: const _CampusMarker(),
                  ),
                  for (final Hostel h in MockData.hostels)
                    Positioned(
                      left: size.width * h.mapPosition.dx - 34,
                      top: 70 + size.height * h.mapPosition.dy * 0.82,
                      child: _PricePin(
                        label: Fmt.rsShort(h.startingRent),
                        selected: h.id == _selected.id,
                        onTap: () => setState(() => _selected = h),
                        semantic: '${h.name}, ${Fmt.rs(h.startingRent)} per month',
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        // Search bar
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.sm,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Material(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdAll,
                    side: BorderSide(color: AppColors.border),
                  ),
                  elevation: 6,
                  shadowColor: AppColors.shadow,
                  child: InkWell(
                    borderRadius: AppRadius.mdAll,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.results),
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 14),
                          Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                          const SizedBox(width: 10),
                          Text('Search this area', style: TextStyle(color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              SquareIconButton(
                icon: Icons.tune_rounded,
                tooltip: 'Filters',
                highlighted: true,
                size: 48,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.filters),
              ),
            ],
          ),
        ),
        // Locate me
        Positioned(
          right: AppSpacing.md,
          bottom: 140,
          child: SquareIconButton(
            icon: Icons.my_location_rounded,
            tooltip: 'My location',
            size: 44,
            onPressed: () => showAppSnack(context, 'Centered on IUB campus', icon: Icons.my_location),
          ),
        ),
        // Selected hostel preview
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (Widget child, Animation<double> a) => FadeTransition(
              opacity: a,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(a),
                child: child,
              ),
            ),
            child: _MapPreviewCard(key: ValueKey<String>(_selected.id), hostel: _selected),
          ),
        ),
      ],
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({super.key, required this.hostel});
  final Hostel hostel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 12,
      shadowColor: AppColors.shadow,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.hostelDetail, arguments: hostel.id),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 72, height: 72, child: PhotoPlaceholder(showLabel: false)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(hostel.name, style: AppText.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(
                      '${Fmt.km(hostel.distanceKm)} from IUB · ★ ${hostel.rating}',
                      style: AppText.caption,
                    ),
                    const SizedBox(height: 6),
                    PriceText(amount: hostel.startingRent, size: 15),
                  ],
                ),
              ),
              RoundActionButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Open ${hostel.name}',
                background: AppColors.primary,
                foreground: AppColors.onPrimary,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.hostelDetail, arguments: hostel.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricePin extends StatelessWidget {
  const _PricePin({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.semantic,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String semantic;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semantic,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.12 : 1,
          duration: const Duration(milliseconds: 160),
          child: Container(
            width: 68,
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surfaceHigh,
              borderRadius: AppRadius.pillAll,
              border: Border.all(color: selected ? AppColors.primary : AppColors.border),
              boxShadow: <BoxShadow>[
                BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? AppColors.onPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CampusMarker extends StatelessWidget {
  const _CampusMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.18),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Icon(Icons.school_rounded, size: 18, color: AppColors.onPrimary),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.85),
            borderRadius: AppRadius.smAll,
          ),
          child: const Text('IUB campus', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

/// Stylised street grid.
class _MapCanvas extends CustomPainter {
  const _MapCanvas(this.palette);

  /// Kept so the map repaints when the theme changes.
  final AppPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.mapBase);

    final Paint block = Paint()..color = palette.mapBlock;
    final Paint park = Paint()..color = palette.mapPark;
    final Paint road = Paint()
      ..color = palette.mapRoad
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final Paint minor = Paint()
      ..color = palette.mapMinor
      ..strokeWidth = 4;
    final Paint highway = Paint()
      ..color = palette.mapHighway
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    // City blocks
    for (double x = 0; x < size.width; x += 70) {
      for (double y = 0; y < size.height; y += 80) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x + 8, y + 8, 54, 64), const Radius.circular(6)),
          block,
        );
      }
    }
    // Parks
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.58, size.height * 0.08, 120, 90), const Radius.circular(18),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.78, 140, 80), const Radius.circular(18),
      ),
      park,
    );

    for (double x = 0; x < size.width; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minor);
    }
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }

    // Main roads
    canvas.drawLine(Offset(0, size.height * 0.30), Offset(size.width, size.height * 0.36), road);
    canvas.drawLine(Offset(size.width * 0.30, 0), Offset(size.width * 0.42, size.height), road);
    canvas.drawLine(Offset(0, size.height * 0.62), Offset(size.width, size.height * 0.55), road);
    // Highway
    canvas.drawLine(
      Offset(size.width * 0.75, 0), Offset(size.width * 0.95, size.height), highway,
    );
  }

  @override
  bool shouldRepaint(covariant _MapCanvas oldDelegate) => oldDelegate.palette != palette;
}
