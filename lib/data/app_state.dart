import 'package:flutter/foundation.dart';

import 'mock_data.dart';
import 'models.dart';

/// Lightweight in-memory UI state shared between screens.
///
/// Kept dependency-free on purpose; swap for Riverpod/Bloc when wiring the
/// backend without touching the widgets (they only listen to notifiers).
class AppState {
  AppState._();
  static final AppState instance = AppState._();

  /// IDs of hostels the student has saved.
  final ValueNotifier<Set<String>> saved = ValueNotifier<Set<String>>(
    MockData.savedHostels.map((Hostel h) => h.id).toSet(),
  );

  /// IDs selected for side-by-side comparison (max 3).
  final ValueNotifier<Set<String>> compare = ValueNotifier<Set<String>>(
    <String>{MockData.alNoor.id, MockData.cholistan.id},
  );

  static const int maxCompare = 3;

  /// Selected bottom-nav tab per role shell.
  final ValueNotifier<int> studentTab = ValueNotifier<int>(0);
  final ValueNotifier<int> ownerTab = ValueNotifier<int>(0);
  final ValueNotifier<int> adminTab = ValueNotifier<int>(0);

  void resetTabs() {
    studentTab.value = 0;
    ownerTab.value = 0;
    adminTab.value = 0;
  }

  bool isSaved(String id) => saved.value.contains(id);

  void toggleSaved(String id) {
    final Set<String> next = Set<String>.of(saved.value);
    if (!next.remove(id)) next.add(id);
    saved.value = next;
    if (!next.contains(id) && compare.value.contains(id)) toggleCompare(id);
  }

  /// Returns false when the compare limit is reached.
  bool toggleCompare(String id) {
    final Set<String> next = Set<String>.of(compare.value);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      if (next.length >= maxCompare) return false;
      next.add(id);
    }
    compare.value = next;
    return true;
  }

  Hostel? hostelById(String id) {
    for (final Hostel h in <Hostel>[...MockData.hostels, MockData.alNoorAnnex]) {
      if (h.id == id) return h;
    }
    return null;
  }
}
