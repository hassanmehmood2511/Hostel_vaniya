import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../widgets/scaffolds.dart';
import 'my_hostels_screen.dart';
import 'owner_dashboard_screen.dart';
import 'owner_profile_screen.dart';
import 'owner_requests_screen.dart';
import 'owner_reviews_screen.dart';

/// Hostel-owner bottom navigation.
class OwnerShell extends StatelessWidget {
  const OwnerShell({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleShell(
      tabIndex: AppState.instance.ownerTab,
      items: const <NavItem>[
        NavItem('Dashboard', Icons.insert_chart_outlined_rounded, Icons.insert_chart_rounded),
        NavItem('Hostels', Icons.apartment_outlined, Icons.apartment_rounded),
        NavItem('Requests', Icons.event_note_outlined, Icons.event_note_rounded),
        NavItem('Reviews', Icons.star_outline_rounded, Icons.star_rounded),
        NavItem('Profile', Icons.person_outline_rounded, Icons.person_rounded),
      ],
      pages: const <Widget>[
        OwnerDashboardScreen(),
        MyHostelsScreen(),
        OwnerRequestsScreen(),
        OwnerReviewsScreen(),
        OwnerProfileScreen(),
      ],
    );
  }
}
