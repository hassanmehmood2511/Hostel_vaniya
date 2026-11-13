import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/common.dart';

/// Screen 5 — verify phone number with a 6-digit code.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.role});
  final UserRole role;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _length = 6;
  final TextEditingController _code = TextEditingController();
  final FocusNode _focus = FocusNode();
  Timer? _timer;
  int _seconds = 42;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _code.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 42);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (_seconds <= 1) t.cancel();
      if (mounted) setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _complete => _code.text.length == _length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const AppBackButton(),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.mdAll),
                child: Icon(Icons.lock_outline_rounded, color: AppColors.accent),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Verify your number', style: AppText.h1),
              const SizedBox(height: AppSpacing.xs),
              Text.rich(
                TextSpan(
                  style: AppText.bodySecondary,
                  children: <InlineSpan>[
                    const TextSpan(text: 'We sent a 6-digit code to '),
                    TextSpan(text: '+92 300 ••• 4567', style: AppText.body.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _OtpBoxes(controller: _code, focus: _focus, length: _length),
              const SizedBox(height: AppSpacing.md),
              if (_seconds > 0)
                Text.rich(
                  TextSpan(
                    style: AppText.caption,
                    children: <InlineSpan>[
                      const TextSpan(text: 'Resend code in '),
                      TextSpan(
                        text: '0:${_seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    _startTimer();
                    showAppSnack(context, 'New code sent', icon: Icons.sms_outlined);
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text('Resend code'),
                ),
              const Spacer(),
              AppButton(
                label: 'Verify and continue',
                onPressed: _complete ? () => AppRoutes.enterApp(context, widget.role) : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Change number',
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Six visual boxes backed by one hidden text field — supports paste and
/// SMS autofill.
class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({required this.controller, required this.focus, required this.length});
  final TextEditingController controller;
  final FocusNode focus;
  final int length;

  @override
  Widget build(BuildContext context) {
    final String text = controller.text;
    return GestureDetector(
      onTap: focus.requestFocus,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 56,
              child: TextField(
                controller: controller,
                focusNode: focus,
                keyboardType: TextInputType.number,
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                maxLength: length,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
          ),
          Semantics(
            label: 'Verification code, ${text.length} of $length digits entered',
            child: ListenableBuilder(
              listenable: focus,
              builder: (BuildContext context, _) => Row(
                children: List<Widget>.generate(length, (int i) {
                  final bool filled = i < text.length;
                  final bool active = focus.hasFocus && i == text.length;
                  return Expanded(
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.only(right: i == length - 1 ? 0 : 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.mdAll,
                        border: Border.all(
                          color: active ? AppColors.accent : AppColors.border,
                          width: active ? 1.5 : 1,
                        ),
                      ),
                      child: Text(filled ? text[i] : '', style: AppText.h2),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
