import 'package:flutter/material.dart';

/// A full set of colour tokens for one brightness.
///
/// Two roles for the brand colour:
/// - [primary]: lime *fill* (buttons, selected pills, badges). Content on it
///   uses [onPrimary].
/// - [accent]: brand colour for *foreground* use (text, icons, borders,
///   indicators). Lime in dark mode; deep olive in light mode, because lime
///   text on white fails contrast.
@immutable
class AppPalette {
  const AppPalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.surfaceHigher,
    required this.border,
    required this.divider,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.star,
    required this.whatsapp,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.shadow,
    required this.photoStart,
    required this.photoEnd,
    required this.mapBase,
    required this.mapBlock,
    required this.mapPark,
    required this.mapMinor,
    required this.mapRoad,
    required this.mapHighway,
  });

  final Brightness brightness;

  // Surfaces
  final Color background;
  final Color surface;
  final Color surfaceHigh;
  final Color surfaceHigher;
  final Color border;
  final Color divider;

  // Brand
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color accentSoft;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Status
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;

  // Misc
  final Color star;
  final Color whatsapp;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color shadow;
  final Color photoStart;
  final Color photoEnd;
  final Color mapBase;
  final Color mapBlock;
  final Color mapPark;
  final Color mapMinor;
  final Color mapRoad;
  final Color mapHighway;

  bool get isDark => brightness == Brightness.dark;

  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    background: Color(0xFF0D1323),
    surface: Color(0xFF192134),
    surfaceHigh: Color(0xFF222B40),
    surfaceHigher: Color(0xFF2B354C),
    border: Color(0xFF2A344B),
    divider: Color(0xFF222B40),
    primary: Color(0xFFC3F729),
    onPrimary: Color(0xFF0D1323),
    accent: Color(0xFFC3F729),
    accentSoft: Color(0x26C3F729),
    textPrimary: Color(0xFFF4F6FB),
    textSecondary: Color(0xFF9AA3B8),
    textMuted: Color(0xFF66708A),
    success: Color(0xFF34D399),
    successSoft: Color(0x2634D399),
    warning: Color(0xFFF5B83D),
    warningSoft: Color(0x26F5B83D),
    danger: Color(0xFFF26B6B),
    dangerSoft: Color(0x26F26B6B),
    info: Color(0xFF6EA8FE),
    infoSoft: Color(0x266EA8FE),
    star: Color(0xFFFACC15),
    whatsapp: Color(0xFF25D366),
    inverseSurface: Color(0xFF2B354C),
    onInverseSurface: Color(0xFFF4F6FB),
    shadow: Color(0x80000000),
    photoStart: Color(0xFF2B354C),
    photoEnd: Color(0xFF1E2639),
    mapBase: Color(0xFF141C2E),
    mapBlock: Color(0xFF172036),
    mapPark: Color(0xFF15281F),
    mapMinor: Color(0xFF1B2438),
    mapRoad: Color(0xFF222C42),
    mapHighway: Color(0xFF2A3550),
  );

  static const AppPalette light = AppPalette(
    brightness: Brightness.light,
    background: Color(0xFFF4F6FA),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFEFF2F7),
    surfaceHigher: Color(0xFFE3E8F0),
    border: Color(0xFFDDE3EC),
    divider: Color(0xFFE8ECF2),
    primary: Color(0xFFC3F729),
    onPrimary: Color(0xFF0D1323),
    accent: Color(0xFF4F7A00),
    accentSoft: Color(0x1F4F7A00),
    textPrimary: Color(0xFF0D1323),
    textSecondary: Color(0xFF555F75),
    textMuted: Color(0xFF8A93A6),
    success: Color(0xFF0E9F6E),
    successSoft: Color(0x1F0E9F6E),
    warning: Color(0xFFB7791F),
    warningSoft: Color(0x24F5B83D),
    danger: Color(0xFFD64545),
    dangerSoft: Color(0x1FD64545),
    info: Color(0xFF2F6FDB),
    infoSoft: Color(0x1F2F6FDB),
    star: Color(0xFFF2B705),
    whatsapp: Color(0xFF128C4A),
    inverseSurface: Color(0xFF1B2333),
    onInverseSurface: Color(0xFFF4F6FB),
    shadow: Color(0x290D1323),
    photoStart: Color(0xFFE6EBF2),
    photoEnd: Color(0xFFD5DCE6),
    mapBase: Color(0xFFEDF1F6),
    mapBlock: Color(0xFFE2E8F0),
    mapPark: Color(0xFFD6ECD9),
    mapMinor: Color(0xFFF8FAFC),
    mapRoad: Color(0xFFFFFFFF),
    mapHighway: Color(0xFFFFE9A8),
  );
}

/// Global access to the active palette's tokens.
///
/// Screens read `AppColors.x`; [ThemeController] swaps the palette and
/// rebuilds the tree, so every widget picks up the new colours.
abstract final class AppColors {
  static AppPalette _p = AppPalette.dark;

  static AppPalette get palette => _p;
  static void use(AppPalette palette) => _p = palette;
  static bool get isDark => _p.isDark;

  static Color get background => _p.background;
  static Color get surface => _p.surface;
  static Color get surfaceHigh => _p.surfaceHigh;
  static Color get surfaceHigher => _p.surfaceHigher;
  static Color get border => _p.border;
  static Color get divider => _p.divider;

  static Color get primary => _p.primary;
  static Color get onPrimary => _p.onPrimary;
  static Color get accent => _p.accent;
  static Color get primarySoft => _p.accentSoft;

  static Color get textPrimary => _p.textPrimary;
  static Color get textSecondary => _p.textSecondary;
  static Color get textMuted => _p.textMuted;

  static Color get success => _p.success;
  static Color get successSoft => _p.successSoft;
  static Color get warning => _p.warning;
  static Color get warningSoft => _p.warningSoft;
  static Color get danger => _p.danger;
  static Color get dangerSoft => _p.dangerSoft;
  static Color get info => _p.info;
  static Color get infoSoft => _p.infoSoft;

  static Color get star => _p.star;
  static Color get whatsapp => _p.whatsapp;
  static Color get inverseSurface => _p.inverseSurface;
  static Color get onInverseSurface => _p.onInverseSurface;
  static Color get shadow => _p.shadow;
  static Color get photoStart => _p.photoStart;
  static Color get photoEnd => _p.photoEnd;
  static Color get mapBase => _p.mapBase;
  static Color get mapBlock => _p.mapBlock;
  static Color get mapPark => _p.mapPark;
  static Color get mapMinor => _p.mapMinor;
  static Color get mapRoad => _p.mapRoad;
  static Color get mapHighway => _p.mapHighway;
}
