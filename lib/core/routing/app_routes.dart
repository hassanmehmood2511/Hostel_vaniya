import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../features/admin/admin_shell.dart';
import '../../features/admin/cities_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/owner/edit_hostel_screen.dart';
import '../../features/owner/manage_rooms_screen.dart';
import '../../features/owner/owner_shell.dart';
import '../../features/owner/verification_screen.dart';
import '../../features/student/compare_screen.dart';
import '../../features/student/filters_screen.dart';
import '../../features/student/hostel_detail_screen.dart';
import '../../features/student/reviews_screen.dart';
import '../../features/student/rooms_rates_screen.dart';
import '../../features/student/search_results_screen.dart';
import '../../features/student/student_shell.dart';

enum UserRole { student, owner, admin }

/// Central route table. All navigation uses these names.
abstract final class AppRoutes {
  static const String welcome = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';

  static const String student = '/student';
  static const String results = '/student/results';
  static const String filters = '/student/filters';
  static const String hostelDetail = '/hostel';
  static const String rooms = '/hostel/rooms';
  static const String reviews = '/hostel/reviews';
  static const String compare = '/student/compare';

  static const String owner = '/owner';
  static const String editHostel = '/owner/edit-hostel';
  static const String manageRooms = '/owner/rooms';
  static const String verification = '/owner/verification';

  static const String admin = '/admin';
  static const String cities = '/admin/cities';

  static String homeFor(UserRole role) => switch (role) {
        UserRole.student => student,
        UserRole.owner => owner,
        UserRole.admin => admin,
      };

  static Hostel _hostelArg(Object? args) {
    if (args is String) return AppState.instance.hostelById(args) ?? MockData.alNoor;
    if (args is Hostel) return args;
    return MockData.alNoor;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    final Widget page = switch (settings.name) {
      welcome => const WelcomeScreen(),
      onboarding => const OnboardingScreen(),
      login => const LoginScreen(),
      signup => const SignupScreen(),
      otp => OtpScreen(role: args is UserRole ? args : UserRole.student),
      student => const StudentShell(),
      results => const SearchResultsScreen(),
      filters => const FiltersScreen(),
      hostelDetail => HostelDetailScreen(hostel: _hostelArg(args)),
      rooms => RoomsRatesScreen(hostel: _hostelArg(args)),
      reviews => ReviewsScreen(hostel: _hostelArg(args)),
      compare => const CompareScreen(),
      owner => const OwnerShell(),
      editHostel => EditHostelScreen(hostel: args == null ? null : _hostelArg(args)),
      manageRooms => ManageRoomsScreen(hostel: _hostelArg(args)),
      verification => const VerificationScreen(),
      admin => const AdminShell(),
      cities => const CitiesScreen(),
      _ => const WelcomeScreen(),
    };

    if (settings.name == filters) {
      return PageRouteBuilder<dynamic>(
        settings: settings,
        fullscreenDialog: true,
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, Animation<double> a, __, Widget child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic))
              .animate(a),
          child: child,
        ),
      );
    }
    return MaterialPageRoute<dynamic>(settings: settings, builder: (_) => page);
  }

  /// Clears the stack and opens the role's home.
  static void enterApp(BuildContext context, UserRole role) {
    AppState.instance.resetTabs();
    Navigator.of(context).pushNamedAndRemoveUntil(homeFor(role), (_) => false);
  }

  static void logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(login, (_) => false);
  }
}
