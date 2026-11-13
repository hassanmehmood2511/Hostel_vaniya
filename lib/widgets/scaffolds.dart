import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_theme.dart';
import 'buttons.dart';

/// Top bar used by pushed (non-tab) screens: back button, title, subtitle
/// and optional actions. Matches the design's rounded-square back button.
class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const <Widget>[],
    this.showBack = true,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: <Widget>[
            if (showBack) ...<Widget>[
              const AppBackButton(),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppText.h2, maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (subtitle != null)
                    Text(subtitle!, style: AppText.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            for (final Widget a in actions) ...<Widget>[const SizedBox(width: AppSpacing.xs), a],
          ],
        ),
      ),
    );
  }
}

/// Header for root tab screens (no back button).
class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, this.overline, this.actions = const <Widget>[]});
  final String title;
  final String? overline;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (overline != null) Text(overline!, style: AppText.caption),
                Text(title, style: AppText.h1),
              ],
            ),
          ),
          for (final Widget a in actions) ...<Widget>[const SizedBox(width: AppSpacing.xs), a],
        ],
      ),
    );
  }
}

class NavItem {
  const NavItem(this.label, this.icon, this.selectedIcon);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Bottom-navigation shell shared by student, owner and admin roles.
/// Uses an IndexedStack so each tab keeps its scroll position.
class RoleShell extends StatefulWidget {
  const RoleShell({
    super.key,
    required this.items,
    required this.pages,
    this.initialIndex = 0,
    this.tabIndex,
  });
  final List<NavItem> items;
  final List<Widget> pages;
  final int initialIndex;

  /// Optional external controller so pushed screens can switch tabs.
  final ValueNotifier<int>? tabIndex;

  @override
  State<RoleShell> createState() => RoleShellState();

  static RoleShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<RoleShellState>();
}

class RoleShellState extends State<RoleShell> {
  late int _index = widget.tabIndex?.value ?? widget.initialIndex;

  @override
  void initState() {
    super.initState();
    widget.tabIndex?.addListener(_syncFromController);
  }

  @override
  void dispose() {
    widget.tabIndex?.removeListener(_syncFromController);
    super.dispose();
  }

  void _syncFromController() {
    final int next = widget.tabIndex!.value;
    if (next != _index && mounted) setState(() => _index = next);
  }

  void goTo(int index) {
    setState(() => _index = index);
    widget.tabIndex?.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (!didPop) goTo(0);
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(index: _index, children: widget.pages),
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: goTo,
            destinations: <Widget>[
              for (final NavItem item in widget.items)
                NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                  tooltip: item.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
