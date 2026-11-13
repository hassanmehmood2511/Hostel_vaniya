import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../widgets/scaffolds.dart';
import 'map_screen.dart';
import 'student_home_screen.dart';
import 'student_profile_screen.dart';
import 'saved_screen.dart';
import 'visit_requests_screen.dart';

/// Student bottom navigation: Home · Map · Saved · Requests · Profile.
class StudentShell extends StatelessWidget {
  const StudentShell({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleShell(
      tabIndex: AppState.instance.studentTab,
      items: const <NavItem>[
        NavItem('Home', Icons.home_outlined, Icons.home_rounded),
        NavItem('Map', Icons.map_outlined, Icons.map_rounded),
        NavItem('Saved', Icons.favorite_border_rounded, Icons.favorite_rounded),
        NavItem('Requests', Icons.event_note_outlined, Icons.event_note_rounded),
        NavItem('Profile', Icons.person_outline_rounded, Icons.person_rounded),
      ],
      pages: const <Widget>[
        StudentHomeScreen(),
        MapScreen(),
        SavedScreen(),
        VisitRequestsScreen(),
        StudentProfileScreen(),
      ],
    );
  }
}
