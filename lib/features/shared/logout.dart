import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../widgets/common.dart';

/// Confirms, then clears the stack back to the login screen.
Future<void> confirmLogout(BuildContext context) async {
  final bool ok = await confirmAction(
    context,
    title: 'Log out?',
    message: 'You\'ll need your phone number and password to log back in.',
    confirmLabel: 'Log out',
    destructive: true,
  );
  if (ok && context.mounted) AppRoutes.logout(context);
}
