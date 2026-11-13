import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/app_state.dart';
import '../../data/mock_data.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';
import '../shared/appearance.dart';
import '../shared/logout.dart';

/// Screen 16 — student profile and settings.
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        TabHeader(
          title: 'Profile',
          actions: <Widget>[
            SquareIconButton(icon: Icons.settings_outlined, tooltip: 'Settings', onPressed: () {}),
          ],
        ),
        Padding(
          padding: AppSpacing.screen,
          child: Row(
            children: <Widget>[
              const InitialsAvatar(name: MockData.studentName, size: 64, highlight: true),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(MockData.studentName, style: AppText.h2),
                    const SizedBox(height: 2),
                    Text(MockData.studentProgram, style: AppText.caption),
                  ],
                ),
              ),
              SquareIconButton(icon: Icons.edit_outlined, tooltip: 'Edit profile', onPressed: () {}),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: AppSpacing.screen,
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: AppState.instance.saved,
            builder: (BuildContext context, Set<String> saved, _) => Row(
              children: <Widget>[
                Expanded(child: _Stat(value: '${saved.length}', label: 'Saved', tab: 2)),
                const SizedBox(width: AppSpacing.xs),
                const Expanded(child: _Stat(value: '3', label: 'Requests', tab: 3)),
                const SizedBox(width: AppSpacing.xs),
                const Expanded(child: _Stat(value: '1', label: 'Reviews')),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SettingsTile(icon: Icons.school_outlined, title: 'My university', value: 'IUB', onTap: () {}),
        SettingsTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          trailing: Switch(value: _notifications, onChanged: (bool v) => setState(() => _notifications = v)),
          onTap: () => setState(() => _notifications = !_notifications),
        ),
        const AppearanceTile(),
        SettingsTile(icon: Icons.language_rounded, title: 'Language', value: 'English', onTap: () {}),
        SettingsTile(icon: Icons.help_outline_rounded, title: 'Help and support', onTap: () {}),
        const Padding(padding: AppSpacing.screen, child: Divider()),
        SettingsTile(
          icon: Icons.logout_rounded,
          title: 'Log out',
          destructive: true,
          onTap: () => confirmLogout(context),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.tab});
  final String value;
  final String label;
  final int? tab;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 14),
      onTap: tab == null ? null : () => RoleShell.of(context)?.goTo(tab!),
      child: Column(
        children: <Widget>[
          Text(value, style: AppText.stat.copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text(label, style: AppText.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
