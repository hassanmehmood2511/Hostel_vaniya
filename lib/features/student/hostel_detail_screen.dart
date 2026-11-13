import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/hostel_cards.dart';
import 'widgets/contact_actions.dart';

/// Screen 10 — hostel detail.
class HostelDetailScreen extends StatefulWidget {
  const HostelDetailScreen({super.key, required this.hostel});
  final Hostel hostel;

  @override
  State<HostelDetailScreen> createState() => _HostelDetailScreenState();
}

class _HostelDetailScreenState extends State<HostelDetailScreen> {
  int _photo = 0;

  Hostel get h => widget.hostel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.background,
            titleSpacing: AppSpacing.md,
            title: Row(
              children: <Widget>[
                const AppBackButton(),
                const Spacer(),
                SquareIconButton(
                  icon: Icons.ios_share_rounded,
                  tooltip: 'Share',
                  onPressed: () => showAppSnack(context, 'Link copied to share', icon: Icons.link),
                ),
                const SizedBox(width: AppSpacing.xs),
                SaveButton(hostelId: h.id, size: 40, filledStyle: true),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  PageView.builder(
                    itemCount: h.photoCount,
                    onPageChanged: (int i) => setState(() => _photo = i),
                    itemBuilder: (_, int i) => const PhotoPlaceholder(
                      label: 'Hostel photo gallery', radius: BorderRadius.zero, iconSize: 30,
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.md,
                    child: Row(
                      children: <Widget>[
                        if (h.verified) ...<Widget>[const VerifiedBadge(), const SizedBox(width: 6)],
                        TagLabel('${h.type.label} hostel'),
                        const Spacer(),
                        TagLabel('${_photo + 1} / ${h.photoCount} photos'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.xl),
            sliver: SliverList.list(
              children: <Widget>[
                Text(h.name, style: AppText.h1),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Icon(Icons.place_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(child: Text(h.address, style: AppText.bodySecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.reviews, arguments: h.id),
                      child: RatingPill(rating: h.rating, count: h.reviewCount),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(Icons.school_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${Fmt.km(h.distanceKm)} from IUB', style: AppText.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SurfaceCard(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.rooms, arguments: h.id),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Rent starts from', style: AppText.caption),
                            const SizedBox(height: 4),
                            PriceText(amount: h.startingRent, size: 22),
                          ],
                        ),
                      ),
                      Text(
                        '${h.rooms.length} room types',
                        style: AppText.title.copyWith(color: AppColors.accent),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.accent),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    for (int i = 0; i < h.facilities.length && i < 4; i++) ...<Widget>[
                      if (i > 0) const SizedBox(width: AppSpacing.xs),
                      Expanded(child: _FacilityTile(facility: h.facilities[i], meals: h.meals)),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SurfaceCard(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                  child: Column(
                    children: <Widget>[
                      InfoRow(label: 'Curfew', value: h.curfew, icon: Icons.schedule_rounded),
                      InfoRow(
                        label: 'Security deposit',
                        value: Fmt.rs(h.deposit),
                        icon: Icons.lock_outline_rounded,
                      ),
                      InfoRow(
                        label: 'Free beds now',
                        value: '${h.freeBeds}',
                        icon: Icons.bed_outlined,
                        valueColor: AppColors.success,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('What students say', style: AppText.h3)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.reviews, arguments: h.id),
                      child: Text('All ${h.reviewCount}'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _ReviewSnippet(review: MockData.reviews.first),
                const SizedBox(height: AppSpacing.lg),
                SurfaceCard(
                  child: Row(
                    children: <Widget>[
                      InitialsAvatar(name: h.owner),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(h.owner, style: AppText.title),
                            Text('Owner · replies in ~2 hours', style: AppText.caption),
                          ],
                        ),
                      ),
                      RoundActionButton(
                        icon: Icons.event_available_rounded,
                        tooltip: 'Request a visit',
                        onPressed: () => showRequestVisitSheet(context, h),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Row(
          children: <Widget>[
            SquareIconButton(
              icon: Icons.calendar_month_rounded,
              tooltip: 'Request a visit',
              size: 52,
              onPressed: () => showRequestVisitSheet(context, h),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: AppButton(label: 'Call', icon: Icons.call_rounded, onPressed: () => callOwner(context, h)),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: AppButton(
                label: 'WhatsApp',
                icon: Icons.chat_rounded,
                variant: AppButtonVariant.whatsapp,
                onPressed: () => whatsappOwner(context, h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FacilityTile extends StatelessWidget {
  const _FacilityTile({required this.facility, required this.meals});
  final Facility facility;
  final int meals;

  @override
  Widget build(BuildContext context) {
    final String label = facility.label == 'Meals' ? '$meals meals' : facility.label;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.mdAll),
      child: Column(
        children: <Widget>[
          Icon(facility.icon, color: AppColors.accent, size: 22),
          const SizedBox(height: 6),
          Text(label, style: AppText.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _ReviewSnippet extends StatelessWidget {
  const _ReviewSnippet({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              InitialsAvatar(name: review.author, size: 32),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(review.author, style: AppText.title)),
              StarRow(rating: review.rating),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(review.text, style: AppText.bodySecondary, maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
