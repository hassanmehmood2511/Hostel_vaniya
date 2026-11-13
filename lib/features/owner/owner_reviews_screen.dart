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
import '../student/reviews_screen.dart' show ReviewCard;

/// Screen 22 — owner reviews with reply.
class OwnerReviewsScreen extends StatefulWidget {
  const OwnerReviewsScreen({super.key});

  @override
  State<OwnerReviewsScreen> createState() => _OwnerReviewsScreenState();
}

class _OwnerReviewsScreenState extends State<OwnerReviewsScreen> {
  int _filter = 0;
  final Set<String> _replied = <String>{};

  @override
  Widget build(BuildContext context) {
    const Hostel h = MockData.alNoor;
    final List<Review> all = MockData.reviews;
    final List<Review> needsReply =
        all.where((Review r) => r.ownerReply == null && !_replied.contains(r.author)).toList();
    final List<Review> list = switch (_filter) {
      0 => needsReply,
      2 => all.where((Review r) => r.rating <= 3).toList(),
      _ => all,
    };

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'Reviews'),
        Padding(
          padding: AppSpacing.screen,
          child: SurfaceCard(
            child: Row(
              children: <Widget>[
                Text(h.rating.toStringAsFixed(1), style: AppText.display),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StarRow(rating: h.rating.round(), size: 16),
                      const SizedBox(height: 4),
                      Text('${h.reviewCount} reviews · ${h.name}', style: AppText.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PillRow(
          children: <Widget>[
            SelectPill(
              label: 'Needs reply · ${needsReply.length}',
              selected: _filter == 0,
              onTap: () => setState(() => _filter = 0),
            ),
            SelectPill(label: 'All', selected: _filter == 1, onTap: () => setState(() => _filter = 1)),
            SelectPill(label: 'Low ratings', selected: _filter == 2, onTap: () => setState(() => _filter = 2)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (list.isEmpty)
          const EmptyState(
            icon: Icons.mark_chat_read_outlined,
            title: 'No reviews waiting',
            message: 'Replying quickly to reviews builds trust with students.',
          ),
        for (final Review r in list)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: r.ownerReply == null && !_replied.contains(r.author)
                ? _ReplyableReview(
                    review: r,
                    onPosted: () {
                      setState(() => _replied.add(r.author));
                      showAppSnack(context, 'Reply posted publicly');
                    },
                  )
                : ReviewCard(review: r),
          ),
      ],
    );
  }
}

class _ReplyableReview extends StatefulWidget {
  const _ReplyableReview({required this.review, required this.onPosted});
  final Review review;
  final VoidCallback onPosted;

  @override
  State<_ReplyableReview> createState() => _ReplyableReviewState();
}

class _ReplyableReviewState extends State<_ReplyableReview> {
  final TextEditingController _reply =
      TextEditingController(text: 'Thanks Saad. A new geyser is being installed this week.');

  @override
  void initState() {
    super.initState();
    _reply.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReviewCard(
      review: widget.review,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _reply,
            maxLines: 3,
            minLines: 2,
            style: AppText.body,
            decoration: InputDecoration(
              hintText: 'Write a public reply…',
              fillColor: AppColors.surfaceHigh,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                onPressed: () => showAppSnack(context, 'Review reported to admin', icon: Icons.flag_outlined),
                icon: const Icon(Icons.flag_outlined, size: 16),
                label: const Text('Report review'),
              ),
              const Spacer(),
              AppButton(
                label: 'Post reply',
                compact: true,
                expand: false,
                onPressed: _reply.text.trim().isEmpty ? null : widget.onPosted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
