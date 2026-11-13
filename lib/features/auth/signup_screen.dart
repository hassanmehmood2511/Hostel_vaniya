import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../data/mock_data.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';

/// Screen 4 — create account with role choice.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  UserRole _role = UserRole.student;
  String? _university = MockData.universityOptions.first;
  bool _agreed = true;
  bool _showTermsError = false;

  void _submit() {
    final bool valid = _form.currentState?.validate() ?? false;
    setState(() => _showTermsError = !_agreed);
    if (valid && _agreed) {
      Navigator.pushNamed(context, AppRoutes.otp, arguments: _role);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isStudent = _role == UserRole.student;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const Align(alignment: Alignment.centerLeft, child: AppBackButton()),
              const SizedBox(height: AppSpacing.lg),
              Text('Create your account', style: AppText.h1),
              const SizedBox(height: AppSpacing.xs),
              Text('Choose how you\'ll use Hostel Vaniya.', style: AppText.bodySecondary),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.school_outlined,
                      title: 'Student',
                      subtitle: 'Find and compare hostels',
                      selected: isStudent,
                      onTap: () => setState(() => _role = UserRole.student),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.apartment_outlined,
                      title: 'Hostel owner',
                      subtitle: 'List and manage hostels',
                      selected: !isStudent,
                      onTap: () => setState(() => _role = UserRole.owner),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              LabeledField(
                label: 'Full name',
                hint: 'e.g. Ahmed Raza',
                initialValue: 'Ahmed Raza',
                prefixIcon: Icons.person_outline_rounded,
                validator: (String? v) => Validators.required(v, field: 'Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              const LabeledField(
                label: 'Phone number',
                hint: '+92 300 1234567',
                initialValue: '+92 300 1234567',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: Validators.pkPhone,
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isStudent
                    ? Column(
                        key: const ValueKey<String>('uni'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const FieldLabel('University'),
                          DropdownButtonFormField<String>(
                            initialValue: _university,
                            isExpanded: true,
                            dropdownColor: AppColors.surfaceHigh,
                            borderRadius: AppRadius.mdAll,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.school_outlined, size: 20),
                            ),
                            items: <DropdownMenuItem<String>>[
                              for (final String u in MockData.universityOptions)
                                DropdownMenuItem<String>(
                                  value: u,
                                  child: Text(u, overflow: TextOverflow.ellipsis),
                                ),
                            ],
                            onChanged: (String? v) => setState(() => _university = v),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey<String>('none')),
              ),
              const PasswordField(
                label: 'Password', initialValue: 'password123', validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                borderRadius: AppRadius.smAll,
                onTap: () => setState(() {
                  _agreed = !_agreed;
                  if (_agreed) _showTermsError = false;
                }),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _agreed,
                      onChanged: (bool? v) => setState(() {
                        _agreed = v ?? false;
                        if (_agreed) _showTermsError = false;
                      }),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: AppText.bodySecondary,
                          children: <InlineSpan>[
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(text: 'terms', style: AppText.body.copyWith(color: AppColors.accent)),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'privacy policy',
                              style: AppText.body.copyWith(color: AppColors.accent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showTermsError)
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 4),
                  child: Text(
                    'Please accept the terms to continue',
                    style: AppText.caption.copyWith(color: AppColors.danger),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: 'Create account', onPressed: _submit),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Already have an account?', style: AppText.bodySecondary),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                    child: const Text('Log in'),
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: SurfaceCard(
        onTap: onTap,
        borderColor: selected ? AppColors.accent : AppColors.border,
        color: selected ? AppColors.primarySoft.withValues(alpha: 0.08) : AppColors.surface,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: selected ? AppColors.accent : AppColors.textSecondary),
                const Spacer(),
                AnimatedOpacity(
                  opacity: selected ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: AppText.title),
            const SizedBox(height: 2),
            Text(subtitle, style: AppText.caption),
          ],
        ),
      ),
    );
  }
}
