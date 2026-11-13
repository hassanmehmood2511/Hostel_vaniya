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

/// Shared label/tone for request status badges.
StatusBadge requestBadge(RequestStatus s) => switch (s) {
      RequestStatus.accepted => const StatusBadge(label: 'Accepted', tone: BadgeTone.success),
      RequestStatus.pending => const StatusBadge(label: 'Pending', tone: BadgeTone.warning),
      RequestStatus.declined => const StatusBadge(label: 'Declined', tone: BadgeTone.danger),
    };

/// Screen 15 — student's visit requests.
class VisitRequestsScreen extends StatefulWidget {
  const VisitRequestsScreen({super.key});

  @override
  State<VisitRequestsScreen> createState() => _VisitRequestsScreenState();
}

class _VisitRequestsScreenState extends State<VisitRequestsScreen> {
  RequestStatus? _filter;

  int _count(RequestStatus s) =>
      MockData.studentRequests.where((VisitRequest r) => r.status == s).length;

  @override
  Widget build(BuildContext context) {
    final List<VisitRequest> list = MockData.studentRequests
        .where((VisitRequest r) => _filter == null || r.status == _filter)
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'My visit requests'),
        PillRow(
          children: <Widget>[
            SelectPill(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
            SelectPill(
              label: 'Pending · ${_count(RequestStatus.pending)}',
              selected: _filter == RequestStatus.pending,
              onTap: () => setState(() => _filter = RequestStatus.pending),
            ),
            SelectPill(
              label: 'Accepted · ${_count(RequestStatus.accepted)}',
              selected: _filter == RequestStatus.accepted,
              onTap: () => setState(() => _filter = RequestStatus.accepted),
            ),
            SelectPill(
              label: 'Declined',
              selected: _filter == RequestStatus.declined,
              onTap: () => setState(() => _filter = RequestStatus.declined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (list.isEmpty)
          const EmptyState(
            icon: Icons.event_busy_rounded,
            title: 'Nothing here',
            message: 'Requests you send to owners will show up here.',
          ),
        for (final VisitRequest r in list)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: _StudentRequestCard(request: r),
          ),
      ],
    );
  }
}

class _StudentRequestCard extends StatelessWidget {
  const _StudentRequestCard({required this.request});
  final VisitRequest request;

  @override
  Widget build(BuildContext context) {
    final bool accepted = request.status == RequestStatus.accepted;
    final Hostel hostel =
        MockData.hostels.firstWhere((Hostel h) => h.name == request.hostelName, orElse: () => MockData.alNoor);
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 52, height: 52, child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(request.hostelName, style: AppText.title),
                    const SizedBox(height: 3),
                    Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(request.when, style: AppText.caption),
                      ],
                    ),
                    Text(request.room, style: AppText.caption),
                  ],
                ),
              ),
              requestBadge(request.status),
            ],
          ),
          if (request.note != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(request.note!, style: AppText.bodySecondary),
          ],
          if (accepted) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                Expanded(
                  child: AppButton(
                    label: 'Call', icon: Icons.call_rounded, compact: true,
                    onPressed: () => callOwner(context, hostel),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton(
                    label: 'WhatsApp', icon: Icons.chat_rounded, compact: true,
                    variant: AppButtonVariant.whatsapp,
                    onPressed: () => whatsappOwner(context, hostel),
                  ),
                ),
              ],
            ),
          ],
          if (request.status == RequestStatus.pending) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                onPressed: () async {
                  final bool ok = await confirmAction(
                    context,
                    title: 'Cancel this request?',
                    message: 'The owner will be told you no longer need the visit.',
                    confirmLabel: 'Cancel request',
                    destructive: true,
                  );
                  if (ok && context.mounted) showAppSnack(context, 'Request cancelled');
                },
                child: const Text('Cancel request'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
