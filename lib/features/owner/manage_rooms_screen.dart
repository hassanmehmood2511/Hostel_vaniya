import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

/// Screen 20 — owner manages rooms, rates and availability.
class ManageRoomsScreen extends StatefulWidget {
  const ManageRoomsScreen({super.key, required this.hostel});
  final Hostel hostel;

  @override
  State<ManageRoomsScreen> createState() => _ManageRoomsScreenState();
}

class _ManageRoomsScreenState extends State<ManageRoomsScreen> {
  late final List<bool> _accepting = widget.hostel.rooms.map((RoomType r) => !r.isFull).toList();
  bool _mealsIncluded = true;

  @override
  Widget build(BuildContext context) {
    final List<RoomType> rooms = widget.hostel.rooms;
    return Scaffold(
      appBar: DetailAppBar(title: 'Rooms and rates', subtitle: widget.hostel.name),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xl),
        children: <Widget>[
          for (int i = 0; i < rooms.length; i++) ...<Widget>[
            SurfaceCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh, borderRadius: AppRadius.mdAll,
                        ),
                        child: Icon(Icons.bed_outlined, color: AppColors.accent),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(rooms[i].name, style: AppText.title),
                            Text('${Fmt.rs(rooms[i].rent)} /bed', style: AppText.price.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit ${rooms[i].name}',
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _editRoom(context, rooms[i]),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Divider(),
                  const SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: <Widget>[
                      rooms[i].isFull
                          ? const StatusBadge(label: 'Full', tone: BadgeTone.danger)
                          : StatusBadge(
                              label: '${rooms[i].freeBeds} of ${rooms[i].totalBeds} beds free',
                              tone: BadgeTone.success,
                            ),
                      const Spacer(),
                      Text('Accepting students', style: AppText.caption),
                      const SizedBox(width: 4),
                      Switch(
                        value: _accepting[i],
                        onChanged: (bool v) => setState(() => _accepting[i] = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
            child: Column(
              children: <Widget>[
                InfoRow(label: 'Security deposit', value: Fmt.rs(widget.hostel.deposit)),
                const Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Meals included in rent', style: AppText.bodySecondary)),
                    Switch(value: _mealsIncluded, onChanged: (bool v) => setState(() => _mealsIncluded = v)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: AppButton(
          label: 'Add room type',
          icon: Icons.add_rounded,
          variant: AppButtonVariant.outlinePrimary,
          onPressed: () => _editRoom(context, null),
        ),
      ),
    );
  }

  void _editRoom(BuildContext context, RoomType? room) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(room == null ? 'Add room type' : 'Edit ${room.name}', style: AppText.h2),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(label: 'Room name', hint: 'e.g. 2-seater', initialValue: room?.name),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: LabeledField(
                        label: 'Rent per bed (Rs)',
                        hint: '12000',
                        initialValue: room?.rent.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: LabeledField(
                        label: 'Total beds',
                        hint: '10',
                        initialValue: room?.totalBeds.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                LabeledField(
                  label: 'Features',
                  hint: 'Attached bath · AC · Study table',
                  initialValue: room?.features,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Save room',
                  onPressed: () {
                    Navigator.pop(ctx);
                    showAppSnack(context, 'Room saved');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
