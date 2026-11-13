import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';
import 'widgets/contact_actions.dart';

/// Screen 12 — reviews (student view).
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.hostel});
  final Hostel hostel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(title: 'Reviews', subtitle: hostel.name),
      body: ListView(
        padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.xl),
        children: <Widget>[
          Padding(
            padding: AppSpacing.screen,
            child: RatingSummaryCard(rating: hostel.rating, count: hostel.reviewCount),
          ),
          const SizedBox(height: AppSpacing.sm),
          PillRow(
            children: <Widget>[
              for (final MapEntry<String, double> e in MockData.reviewBreakdown.entries)
                SelectPill(label: '${e.key} ${e.value}', selected: false, onTap: null, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final Review r in MockData.reviews.take(2))
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
              child: ReviewCard(review: r),
            ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: AppButton(
          label: 'Write a review',
          icon: Icons.rate_review_outlined,
          variant: AppButtonVariant.outlinePrimary,
          onPressed: () => showWriteReviewSheet(context, hostel),
        ),
      ),
    );
  }
}

/// Big rating + 5→1 distribution bars. Shared with the owner reviews screen.
class RatingSummaryCard extends StatelessWidget {
  const RatingSummaryCard({super.key, required this.rating, required this.count});
  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(rating.toStringAsFixed(1), style: AppText.display.copyWith(fontSize: 40)),
              StarRow(rating: rating.round()),
              const SizedBox(height: 4),
              Text('$count reviews', style: AppText.caption),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              children: <Widget>[
                for (int i = 0; i < 5; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 12, child: Text('${5 - i}', style: AppText.caption)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.pillAll,
                            child: LinearProgressIndicator(
                              value: MockData.ratingDistribution[i],
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Review card with optional owner reply and footer actions.
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review, this.footer});
  final Review review;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              InitialsAvatar(name: review.author, size: 36),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(review.author, style: AppText.title),
                    Text('${review.stayed} · ${review.ago}', style: AppText.caption),
                  ],
                ),
              ),
              StarRow(rating: review.rating),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(review.text, style: AppText.body),
          if (review.ownerReply != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: AppRadius.mdAll,
                border: Border(left: BorderSide(color: AppColors.accent, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.reply_rounded, size: 15, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text('Owner replied', style: AppText.caption.copyWith(color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(review.ownerReply!, style: AppText.bodySecondary),
                ],
              ),
            ),
          ],
          if (footer != null) ...<Widget>[const SizedBox(height: AppSpacing.sm), footer!],
        ],
      ),
    );
  }
}
