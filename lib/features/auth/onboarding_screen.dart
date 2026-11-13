import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';

class _Slide {
  const _Slide(this.title, this.body, this.visual);
  final String title;
  final String body;
  final Widget visual;
}

/// Screen 2 — onboarding carousel.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_Slide> _slides = <_Slide>[
    _Slide(
      'Hostels near your university, verified.',
      'Compare rent, rooms and rules. Then call or WhatsApp the owner directly.',
      _VerifiedVisual(),
    ),
    _Slide(
      'Compare before you commit.',
      'Put up to three hostels side by side — rent, distance, meals and curfew.',
      _CompareVisual(),
    ),
    _Slide(
      'Book a visit in two taps.',
      'Pick a time, the owner confirms, and you see the room before paying anything.',
      _VisitVisual(),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _slides.length - 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.signup);
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool last = _page == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs, top: AppSpacing.xxs),
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signup),
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (int i) => setState(() => _page = i),
                itemBuilder: (BuildContext context, int i) => Padding(
                  padding: AppSpacing.screen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: Center(child: _slides[i].visual)),
                      const SizedBox(height: AppSpacing.xl),
                      _Dots(count: _slides.length, index: _page),
                      const SizedBox(height: AppSpacing.lg),
                      Text(_slides[i].title, style: AppText.h1),
                      const SizedBox(height: AppSpacing.xs),
                      Text(_slides[i].body, style: AppText.bodySecondary),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppButton(
                label: last ? 'Get started' : 'Next',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${index + 1} of $count',
      child: Row(
        children: List<Widget>.generate(
          count,
          (int i) => AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.only(right: 6),
            width: i == index ? 22 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index ? AppColors.accent : AppColors.surfaceHigher,
              borderRadius: AppRadius.pillAll,
            ),
          ),
        ),
      ),
    );
  }
}

class _VerifiedVisual extends StatelessWidget {
  const _VerifiedVisual();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.95,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const Positioned.fill(
            child: PhotoPlaceholder(radius: AppRadius.xlAll, iconSize: 32),
          ),
          const Positioned(top: 14, left: 14, child: VerifiedBadge()),
          Positioned(
            right: -6,
            top: 90,
            child: _FloatingCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Monthly rent', style: AppText.caption.copyWith(fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('Rs 12,000', style: AppText.price.copyWith(fontSize: 18)),
                ],
              ),
            ),
          ),
          Positioned(
            left: -6,
            bottom: 18,
            child: _FloatingCard(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.school_rounded, size: 16, color: AppColors.accent),
                  const SizedBox(width: 6),
                  const Text('0.8 km from IUB', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareVisual extends StatelessWidget {
  const _CompareVisual();

  @override
  Widget build(BuildContext context) {
    Widget col(String name, String rent, bool highlight) => Expanded(
          child: SurfaceCard(
            borderColor: highlight ? AppColors.accent : null,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const AspectRatio(aspectRatio: 1.2, child: PhotoPlaceholder(showLabel: false)),
                const SizedBox(height: 10),
                Text(name, style: AppText.title, maxLines: 2),
                const SizedBox(height: 6),
                Text(rent, style: AppText.price),
                const SizedBox(height: 10),
                Row(children: <Widget>[
                  Icon(Icons.wifi_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Icon(Icons.restaurant_rounded, size: 16, color: AppColors.textSecondary),
                ]),
              ],
            ),
          ),
        );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        col('Al-Noor Boys', 'Rs 12,000', false),
        const SizedBox(width: AppSpacing.sm),
        col('Cholistan Residency', 'Rs 9,500', true),
      ],
    );
  }
}

class _VisitVisual extends StatelessWidget {
  const _VisitVisual();

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text('Al-Noor Boys Hostel', style: AppText.h3)),
              const StatusBadge(label: 'Accepted', tone: BadgeTone.success),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: <Widget>[
            Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text('Sat 16 Nov, 4:00 PM', style: AppText.caption),
          ]),
          const SizedBox(height: 14),
          Text('Owner confirmed your visit. Bring your student card.', style: AppText.bodySecondary),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton(label: 'Call', icon: Icons.call_rounded, compact: true, onPressed: () {}),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'WhatsApp', icon: Icons.chat_rounded, compact: true,
                  variant: AppButtonVariant.whatsapp, onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  const _FloatingCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }
}
