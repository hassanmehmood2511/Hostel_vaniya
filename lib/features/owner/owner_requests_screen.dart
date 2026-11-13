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
import '../student/visit_requests_screen.dart' show requestBadge;
import '../student/widgets/contact_actions.dart';

/// Screen 21 — visit requests received by the owner.
class OwnerRequestsScreen extends StatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen> {
  int _tab = 0;

  /// Local decisions so Accept/Decline visibly move cards between tabs.
  final Map<String, RequestStatus> _decided = <String, RequestStatus>{};

  RequestStatus _statusOf(VisitRequest r) => _decided[r.studentName] ?? r.status;

  @override
  Widget build(BuildContext context) {
    final List<VisitRequest> all = MockData.ownerRequests;
    final List<VisitRequest> fresh = all.where((VisitRequest r) => _statusOf(r) == RequestStatus.pending).toList();
    final List<VisitRequest> accepted =
        all.where((VisitRequest r) => _statusOf(r) == RequestStatus.accepted).toList();
    final List<VisitRequest> past =
        all.where((VisitRequest r) => _statusOf(r) == RequestStatus.declined).toList();
    final List<VisitRequest> list = <List<VisitRequest>>[fresh, accepted, past][_tab];

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: <Widget>[
        const TabHeader(title: 'Visit requests'),
        Padding(
          padding: AppSpacing.screen,
          child: SegmentedTabs(
            labels: <String>['New · ${fresh.length}', 'Accepted', 'Past'],
            selected: _tab,
            onChanged: (int i) => setState(() => _tab = i),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (list.isEmpty)
          const EmptyState(
            icon: Icons.inbox_outlined,
            title: 'All caught up',
            message: 'New visit requests from students will appear here.',
          ),
        for (final VisitRequest r in list)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: _OwnerRequestCard(
              request: r,
              status: _statusOf(r),
              onDecide: (RequestStatus s) {
                setState(() => _decided[r.studentName] = s);
                showAppSnack(
                  context,
                  s == RequestStatus.accepted
                      ? 'Visit confirmed. ${r.studentName} has been notified.'
                      : 'Request declined',
                  icon: s == RequestStatus.accepted ? Icons.check_circle : Icons.close,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _OwnerRequestCard extends StatelessWidget {
  const _OwnerRequestCard({required this.request, required this.status, required this.onDecide});
  final VisitRequest request;
  final RequestStatus status;
  final ValueChanged<RequestStatus> onDecide;

  @override
  Widget build(BuildContext context) {
    final bool isNew = status == RequestStatus.pending;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              InitialsAvatar(name: request.studentName),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(request.studentName, style: AppText.title),
                    Text(request.program, style: AppText.caption),
                  ],
                ),
              ),
              if (isNew)
                const StatusBadge(label: 'New', tone: BadgeTone.warning)
              else
                requestBadge(status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              FacilityChip(label: request.room, icon: Icons.bed_outlined),
              FacilityChip(label: request.when, icon: Icons.calendar_today_rounded),
            ],
          ),
          if (request.message != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text('“${request.message}”', style: AppText.bodySecondary.copyWith(fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              if (isNew) ...<Widget>[
                Expanded(
                  child: AppButton(
                    label: 'Decline',
                    compact: true,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => onDecide(RequestStatus.declined),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton(
                    label: 'Accept', compact: true, onPressed: () => onDecide(RequestStatus.accepted),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ] else
                const Spacer(),
              RoundActionButton(
                icon: Icons.call_rounded,
                tooltip: 'Call student',
                onPressed: () => callOwner(context, MockData.alNoor),
              ),
              const SizedBox(width: AppSpacing.xs),
              RoundActionButton(
                icon: Icons.chat_rounded,
                tooltip: 'WhatsApp student',
                foreground: AppColors.whatsapp,
                onPressed: () => showAppSnack(context, 'Opening WhatsApp with ${request.studentName}',
                    icon: Icons.chat_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
