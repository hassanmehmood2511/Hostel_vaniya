import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';
import 'app_theme.dart';

/// Owns the user's appearance choice (System / Light / Dark), keeps
/// [AppColors] on the matching palette and saves the choice on the device.
class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  static const String _prefsKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  Brightness get _platformBrightness =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  /// The brightness actually on screen after resolving "System".
  Brightness get effectiveBrightness => switch (_mode) {
        ThemeMode.light => Brightness.light,
        ThemeMode.dark => Brightness.dark,
        ThemeMode.system => _platformBrightness,
      };

  /// Call once before `runApp`.
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? saved = prefs.getString(_prefsKey);
      _mode = ThemeMode.values.firstWhere(
        (ThemeMode m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    } catch (_) {
      _mode = ThemeMode.system; // Storage unavailable: fall back quietly.
    }
    _applyPalette();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    _applyPalette();
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, mode.name);
    } catch (_) {
      // Not fatal: the choice still applies for this session.
    }
  }

  @override
  void didChangePlatformBrightness() {
    if (_mode != ThemeMode.system) return;
    _applyPalette();
    notifyListeners();
  }

  void _applyPalette() {
    final AppPalette palette =
        effectiveBrightness == Brightness.dark ? AppPalette.dark : AppPalette.light;
    AppColors.use(palette);
    SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayFor(palette));
  }

  static String labelFor(ThemeMode m) => switch (m) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}
