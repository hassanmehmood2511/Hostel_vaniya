import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';

/// Screen 3 — log in.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  UserRole _demoRole = UserRole.student;

  void _submit() {
    if (_form.currentState?.validate() ?? false) {
      AppRoutes.enterApp(context, _demoRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              Align(alignment: Alignment.centerLeft, child: AppBackButton(
                onPressed: () => Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, AppRoutes.welcome),
              )),
              const SizedBox(height: AppSpacing.xl),
              Text('Welcome back', style: AppText.h1),
              const SizedBox(height: AppSpacing.xs),
              Text('Log in to see hostels near your campus.', style: AppText.bodySecondary),
              const SizedBox(height: AppSpacing.xl),
              const LabeledField(
                label: 'Phone number',
                hint: '+92 300 1234567',
                initialValue: '+92 300 1234567',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: Validators.pkPhone,
              ),
              const SizedBox(height: AppSpacing.md),
              const PasswordField(
                label: 'Password', initialValue: 'password123', validator: Validators.password,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => showAppSnack(
                    context, 'We\'ll send a reset code to your phone.', icon: Icons.sms_outlined,
                  ),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppButton(label: 'Log in', onPressed: _submit),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  const Expanded(child: const Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text('or', style: AppText.caption),
                  ),
                  const Expanded(child: const Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: () => AppRoutes.enterApp(context, UserRole.student),
              ),
              if (kDebugMode) ...<Widget>[
                const SizedBox(height: AppSpacing.xl),
                _DemoRolePicker(
                  role: _demoRole,
                  onChanged: (UserRole r) => setState(() => _demoRole = r),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('New here?', style: AppText.bodySecondary),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                    child: const Text('Create account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Debug-only helper so the owner and admin flows can be reviewed without
/// a backend. Hidden in release builds.
class _DemoRolePicker extends StatelessWidget {
  const _DemoRolePicker({required this.role, required this.onChanged});
  final UserRole role;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      borderColor: AppColors.border,
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.developer_mode_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text('Demo mode · log in as', style: AppText.label),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            children: <Widget>[
              SelectPill(
                label: 'Student', dense: true, selected: role == UserRole.student,
                onTap: () => onChanged(UserRole.student),
              ),
              SelectPill(
                label: 'Hostel owner', dense: true, selected: role == UserRole.owner,
                onTap: () => onChanged(UserRole.owner),
              ),
              SelectPill(
                label: 'Admin', dense: true, selected: role == UserRole.admin,
                onTap: () => onChanged(UserRole.admin),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
