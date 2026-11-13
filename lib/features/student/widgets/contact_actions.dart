import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/chips_badges.dart';
import '../../../widgets/common.dart';

/// Contact actions are UI-only for now.
/// TODO(backend): use `url_launcher` with `tel:` and `https://wa.me/92…`.
void callOwner(BuildContext context, Hostel hostel) =>
    showAppSnack(context, 'Calling ${hostel.owner} · ${hostel.phone}', icon: Icons.call_rounded);

void whatsappOwner(BuildContext context, Hostel hostel) =>
    showAppSnack(context, 'Opening WhatsApp chat with ${hostel.owner}', icon: Icons.chat_rounded);

/// Bottom sheet to request a visit: room type, day, time and a note.
Future<void> showRequestVisitSheet(BuildContext context, Hostel hostel) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext ctx) => _RequestVisitSheet(hostel: hostel),
  );
}

class _RequestVisitSheet extends StatefulWidget {
  const _RequestVisitSheet({required this.hostel});
  final Hostel hostel;

  @override
  State<_RequestVisitSheet> createState() => _RequestVisitSheetState();
}

class _RequestVisitSheetState extends State<_RequestVisitSheet> {
  static const List<String> _days = <String>['Today', 'Sat 16', 'Sun 17', 'Mon 18', 'Tue 19'];
  static const List<String> _times = <String>['11:00 AM', '1:00 PM', '4:00 PM', '6:00 PM'];

  late String _room = widget.hostel.rooms.firstWhere(
    (RoomType r) => !r.isFull,
    orElse: () => widget.hostel.rooms.first,
  ).name;
  int _day = 1;
  int _time = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Request a visit', style: AppText.h2),
              const SizedBox(height: 2),
              Text(widget.hostel.name, style: AppText.bodySecondary),
              const SizedBox(height: AppSpacing.lg),
              const FieldLabel('Room type'),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  for (final RoomType r in widget.hostel.rooms)
                    SelectPill(
                      label: r.isFull ? '${r.name} · Full' : r.name,
                      selected: _room == r.name,
                      onTap: r.isFull ? null : () => setState(() => _room = r.name),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const FieldLabel('Day'),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  for (int i = 0; i < _days.length; i++)
                    SelectPill(label: _days[i], selected: _day == i, onTap: () => setState(() => _day = i)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const FieldLabel('Time'),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  for (int i = 0; i < _times.length; i++)
                    SelectPill(label: _times[i], selected: _time == i, onTap: () => setState(() => _time = i)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const LabeledField(
                label: 'Message to owner (optional)',
                hint: 'e.g. Is the room available from December?',
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  Icon(Icons.schedule_rounded, size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(child: Text('Owners usually reply within 2 hours.', style: AppText.caption)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Send request',
                icon: Icons.send_rounded,
                onPressed: () {
                  Navigator.pop(context);
                  showAppSnack(
                    context,
                    'Visit request sent for ${_days[_day]}, ${_times[_time]}. Track it in Requests.',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet to write a review.
Future<void> showWriteReviewSheet(BuildContext context, Hostel hostel) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext ctx) => _WriteReviewSheet(hostel: hostel),
  );
}

class _WriteReviewSheet extends StatefulWidget {
  const _WriteReviewSheet({required this.hostel});
  final Hostel hostel;

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  int _stars = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Write a review', style: AppText.h2),
              const SizedBox(height: 2),
              Text(widget.hostel.name, style: AppText.bodySecondary),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: List<Widget>.generate(
                  5,
                  (int i) => IconButton(
                    tooltip: '${i + 1} star${i == 0 ? '' : 's'}',
                    iconSize: 34,
                    onPressed: () => setState(() => _stars = i + 1),
                    icon: Icon(
                      i < _stars ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: i < _stars ? AppColors.star : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const LabeledField(
                label: 'Your experience',
                hint: 'Cleanliness, food, safety, Wi-Fi, warden…',
                maxLines: 4,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Post review',
                onPressed: _stars == 0
                    ? null
                    : () {
                        Navigator.pop(context);
                        showAppSnack(context, 'Thanks! Your review is live.');
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
