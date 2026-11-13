import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  await ThemeController.instance.init();
  runApp(const HostelVaniyaApp());
}

class HostelVaniyaApp extends StatefulWidget {
  const HostelVaniyaApp({super.key});

  @override
  State<HostelVaniyaApp> createState() => _HostelVaniyaAppState();
}

class _HostelVaniyaAppState extends State<HostelVaniyaApp> {
  final ThemeController _theme = ThemeController.instance;

  @override
  void initState() {
    super.initState();
    _theme.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _theme.removeListener(_onThemeChanged);
    super.dispose();
  }

  /// Screens read colours from the active palette, so after a switch every
  /// element is rebuilt in place. Navigation stack and screen state are kept.
  void _onThemeChanged() {
    setState(() {});
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Vaniya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _theme.mode,
      // Colours switch instantly app-wide; match that for Material widgets.
      themeAnimationDuration: Duration.zero,
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      builder: (BuildContext context, Widget? child) {
        // Respect user font scaling but cap it so dense cards don't break.
        final MediaQueryData mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.3),
          ),
          child: child!,
        );
      },
    );
  }
}
