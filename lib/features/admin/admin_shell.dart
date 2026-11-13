import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../widgets/scaffolds.dart';
import 'admin_hostels_screen.dart';
import 'admin_overview_screen.dart';
import 'approvals_screen.dart';
import 'reports_screen.dart';
import 'users_screen.dart';

/// Admin bottom navigation.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleShell(
      tabIndex: AppState.instance.adminTab,
      items: const <NavItem>[
        NavItem('Overview', Icons.insert_chart_outlined_rounded, Icons.insert_chart_rounded),
        NavItem('Approvals', Icons.verified_outlined, Icons.verified_rounded),
        NavItem('Hostels', Icons.apartment_outlined, Icons.apartment_rounded),
        NavItem('Users', Icons.group_outlined, Icons.group_rounded),
        NavItem('Reports', Icons.flag_outlined, Icons.flag_rounded),
      ],
      pages: const <Widget>[
        AdminOverviewScreen(),
        ApprovalsScreen(),
        AdminHostelsScreen(),
        UsersScreen(),
        ReportsScreen(),
      ],
    );
  }
}
