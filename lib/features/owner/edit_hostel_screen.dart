import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips_badges.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffolds.dart';

/// Screen 19 — add / edit a hostel listing.
class EditHostelScreen extends StatefulWidget {
  const EditHostelScreen({super.key, this.hostel});

  /// Null when adding a new hostel.
  final Hostel? hostel;

  @override
  State<EditHostelScreen> createState() => _EditHostelScreenState();
}

class _EditHostelScreenState extends State<EditHostelScreen> {
  static const int _maxPhotos = 15;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late int _photos = widget.hostel?.photoCount ?? 0;
  late int _type = widget.hostel?.type == HostelType.girls ? 1 : 0;
  late final Set<String> _facilities =
      widget.hostel?.facilities.map((Facility f) => f.label).toSet() ?? <String>{};

  bool get _isNew => widget.hostel == null;

  void _save({required bool submit}) {
    if (!(_form.currentState?.validate() ?? false)) return;
    Navigator.pop(context);
    showAppSnack(
      context,
      submit ? 'Submitted. Admin usually reviews within 24 hours.' : 'Draft saved',
      icon: submit ? Icons.send_rounded : Icons.save_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Hostel? h = widget.hostel;
    return Scaffold(
      appBar: DetailAppBar(
        title: _isNew ? 'Add hostel' : 'Edit hostel',
        actions: <Widget>[
          TextButton(onPressed: () => _save(submit: false), child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xl),
          children: <Widget>[
            FieldLabel('Photos ($_photos of $_maxPhotos)'),
            SizedBox(
              height: 84,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < _photos && i < 6; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: SizedBox(
                        width: 84,
                        child: Stack(
                          children: <Widget>[
                            const Positioned.fill(child: PhotoPlaceholder(showLabel: false, iconSize: 18)),
                            if (i == 0)
                              const Positioned(left: 6, bottom: 6, child: StatusBadge(label: 'Cover', tone: BadgeTone.brand)),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: InkWell(
                                onTap: () => setState(() => _photos--),
                                customBorder: const CircleBorder(),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: AppColors.background.withValues(alpha: 0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_rounded, size: 14, semanticLabel: 'Remove photo'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  InkWell(
                    borderRadius: AppRadius.mdAll,
                    onTap: _photos >= _maxPhotos ? null : () => setState(() => _photos++),
                    child: Container(
                      width: 84,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.mdAll,
                        border: Border.all(color: AppColors.border, width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add_photo_alternate_outlined, color: AppColors.accent),
                          const SizedBox(height: 4),
                          Text('Add', style: AppText.caption),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            LabeledField(
              label: 'Hostel name',
              hint: 'e.g. Al-Noor Boys Hostel',
              initialValue: h?.name,
              validator: (String? v) => Validators.required(v, field: 'Hostel name'),
            ),
            const SizedBox(height: AppSpacing.md),
            const FieldLabel('Hostel type'),
            SegmentedTabs(
              labels: const <String>['Boys', 'Girls'],
              selected: _type,
              onChanged: (int i) => setState(() => _type = i),
            ),
            const SizedBox(height: AppSpacing.md),
            LabeledField(
              label: 'Address',
              hint: 'Street, area, city',
              initialValue: h?.address,
              prefixIcon: Icons.place_outlined,
              validator: (String? v) => Validators.required(v, field: 'Address'),
            ),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: AppRadius.mdAll,
              child: SizedBox(
                height: 120,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CustomPaint(painter: _MiniMapPainter(AppColors.palette)),
                    ),
                    Center(child: Icon(Icons.location_on_rounded, color: AppColors.accent, size: 36)),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: AppButton(
                        label: 'Adjust pin',
                        compact: true,
                        expand: false,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => showAppSnack(context, 'Drag the map to move the pin', icon: Icons.pan_tool_alt_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: LabeledField(
                    label: 'Call number',
                    hint: '0300 1234567',
                    initialValue: h?.phone,
                    keyboardType: TextInputType.phone,
                    validator: Validators.pkPhone,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: LabeledField(
                    label: 'WhatsApp number',
                    hint: '0300 1234567',
                    initialValue: h?.phone,
                    keyboardType: TextInputType.phone,
                    validator: Validators.pkPhone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const FieldLabel('Facilities'),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final Facility f in Facilities.all)
                  SelectPill(
                    label: f.label,
                    icon: f.icon,
                    selected: _facilities.contains(f.label),
                    onTap: () => setState(
                      () => _facilities.contains(f.label)
                          ? _facilities.remove(f.label)
                          : _facilities.add(f.label),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            LabeledField(
              label: 'Hostel rules (optional)',
              hint: 'Curfew, guests, cooking…',
              initialValue: h == null ? null : 'Curfew ${h.curfew}. No guests after 8 PM.',
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: AppButton(label: 'Save and submit for review', onPressed: () => _save(submit: true)),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  _MiniMapPainter(this.palette);
  final AppPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.mapBase);
    final Paint minor = Paint()
      ..color = palette.mapRoad
      ..strokeWidth = 3;
    for (double x = 0; x < size.width; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x + 20, size.height), minor);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 8), minor);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniMapPainter oldDelegate) => oldDelegate.palette != palette;
}
