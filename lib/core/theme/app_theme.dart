import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Typography scale. Colours follow the active palette, so these are getters.
abstract final class AppText {
  static const String fontFamily = 'PlusJakartaSans';

  static TextStyle get display => TextStyle(
        fontSize: 30, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -0.6,
        color: AppColors.textPrimary,
      );
  static TextStyle get h1 => TextStyle(
        fontSize: 24, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.4,
        color: AppColors.textPrimary,
      );
  static TextStyle get h2 => TextStyle(
        fontSize: 20, fontWeight: FontWeight.w700, height: 1.25, letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );
  static TextStyle get h3 => TextStyle(
        fontSize: 16, fontWeight: FontWeight.w700, height: 1.3, color: AppColors.textPrimary,
      );
  static TextStyle get title => TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600, height: 1.3, color: AppColors.textPrimary,
      );
  static TextStyle get body => TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.45, color: AppColors.textPrimary,
      );
  static TextStyle get bodySecondary => TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.45, color: AppColors.textSecondary,
      );
  static TextStyle get caption => TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, height: 1.35, color: AppColors.textSecondary,
      );
  static TextStyle get label => TextStyle(
        fontSize: 13, fontWeight: FontWeight.w600, height: 1.2, color: AppColors.textSecondary,
      );
  static TextStyle get price => TextStyle(
        fontSize: 16, fontWeight: FontWeight.w800, height: 1.2, color: AppColors.accent,
      );
  static TextStyle get stat => TextStyle(
        fontSize: 26, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );
}

abstract final class AppTheme {
  static ThemeData get dark => build(AppPalette.dark);
  static ThemeData get light => build(AppPalette.light);

  static SystemUiOverlayStyle overlayFor(AppPalette p) => SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: p.isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: p.brightness,
        systemNavigationBarColor: p.background,
        systemNavigationBarIconBrightness: p.isDark ? Brightness.light : Brightness.dark,
      );

  static ThemeData build(AppPalette p) {
    TextStyle t(double size, FontWeight w, Color c, {double height = 1.3, double ls = 0}) => TextStyle(
          fontFamily: AppText.fontFamily, fontSize: size, fontWeight: w, color: c,
          height: height, letterSpacing: ls,
        );

    final ColorScheme scheme = ColorScheme(
      brightness: p.brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      secondary: p.accent,
      onSecondary: p.surface,
      surface: p.background,
      onSurface: p.textPrimary,
      onSurfaceVariant: p.textSecondary,
      surfaceContainerLowest: p.background,
      surfaceContainerLow: p.surface,
      surfaceContainer: p.surface,
      surfaceContainerHigh: p.surfaceHigh,
      surfaceContainerHighest: p.surfaceHigher,
      outline: p.border,
      outlineVariant: p.divider,
      error: p.danger,
      onError: Colors.white,
      inverseSurface: p.inverseSurface,
      onInverseSurface: p.onInverseSurface,
      shadow: p.shadow,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      fontFamily: AppText.fontFamily,
      scaffoldBackgroundColor: p.background,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: base.textTheme
          .copyWith(
            displaySmall: t(30, FontWeight.w800, p.textPrimary, height: 1.15, ls: -0.6),
            headlineMedium: t(24, FontWeight.w700, p.textPrimary, height: 1.2, ls: -0.4),
            headlineSmall: t(20, FontWeight.w700, p.textPrimary, height: 1.25),
            titleLarge: t(16, FontWeight.w700, p.textPrimary),
            titleMedium: t(15, FontWeight.w600, p.textPrimary),
            bodyLarge: t(14, FontWeight.w400, p.textPrimary, height: 1.45),
            bodyMedium: t(14, FontWeight.w400, p.textPrimary, height: 1.45),
            bodySmall: t(12, FontWeight.w500, p.textSecondary, height: 1.35),
            labelLarge: t(15, FontWeight.w600, p.textPrimary),
          )
          .apply(fontFamily: AppText.fontFamily),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        titleTextStyle: t(20, FontWeight.w700, p.textPrimary),
        iconTheme: IconThemeData(color: p.textPrimary),
        systemOverlayStyle: overlayFor(p),
      ),
      dividerTheme: DividerThemeData(color: p.divider, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: p.textPrimary, size: 22),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          disabledBackgroundColor: p.surfaceHigher,
          disabledForegroundColor: p.textMuted,
          minimumSize: const Size(64, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: const TextStyle(
            fontFamily: AppText.fontFamily, fontSize: 15, fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.textPrimary,
          minimumSize: const Size(64, 52),
          side: BorderSide(color: p.border),
          backgroundColor: p.surface,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: const TextStyle(
            fontFamily: AppText.fontFamily, fontSize: 15, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.accent,
          textStyle: const TextStyle(
            fontFamily: AppText.fontFamily, fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: t(14, FontWeight.w400, p.textMuted, height: 1.45),
        labelStyle: t(13, FontWeight.w600, p.textSecondary),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIconColor: p.textSecondary,
        suffixIconColor: p.textSecondary,
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll, borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll, borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll, borderSide: BorderSide(color: p.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll, borderSide: BorderSide(color: p.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll, borderSide: BorderSide(color: p.danger, width: 1.5),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => s.contains(WidgetState.selected)
              ? p.onPrimary
              : (p.isDark ? p.textSecondary : Colors.white),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => s.contains(WidgetState.selected) ? p.primary : p.surfaceHigher,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) =>
              s.contains(WidgetState.selected) || p.isDark ? Colors.transparent : p.border,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => s.contains(WidgetState.selected) ? p.primary : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(p.onPrimary),
        side: BorderSide(color: p.textMuted, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: p.accent,
        inactiveTrackColor: p.surfaceHigher,
        thumbColor: p.accent,
        overlayColor: p.accentSoft,
        trackHeight: 4,
        rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 9),
        showValueIndicator: ShowValueIndicator.never,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.isDark ? p.background : p.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        height: 68,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => IconThemeData(
            size: 24,
            color: s.contains(WidgetState.selected) ? p.accent : p.textMuted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (Set<WidgetState> s) => TextStyle(
            fontFamily: AppText.fontFamily,
            fontSize: 11,
            fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: s.contains(WidgetState.selected) ? p.accent : p.textMuted,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.surfaceHigher,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
        titleTextStyle: t(16, FontWeight.w700, p.textPrimary),
        contentTextStyle: t(14, FontWeight.w400, p.textSecondary, height: 1.45),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        textStyle: t(14, FontWeight.w500, p.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: p.border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.inverseSurface,
        contentTextStyle: t(14, FontWeight.w500, p.onInverseSurface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.accent,
        linearTrackColor: p.surfaceHigher,
        refreshBackgroundColor: p.surface,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.textSecondary,
        textColor: p.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        side: BorderSide(color: p.border),
        labelStyle: t(12, FontWeight.w500, p.textPrimary),
      ),
    );
  }
}
