# Hostel Vaniya

Student hostel finder for Bahawalpur (IUB and nearby campuses). Students find, compare and request visits to verified hostels. Owners list and manage hostels. Admins approve listings and handle reports.

This repo currently contains the **complete UI for version 1 (30 screens)**, built in Flutter with sample data. There is no backend yet. Every screen reads from `lib/data/mock_data.dart`.

## Run it

Requires **Flutter 3.35 or newer** (Dart 3.9+). Version 1 targets **Android + Chrome (for testing)**. iOS comes later.

```bash
# 1. One time only: generate the Android and Web platform folders (existing files are kept)
flutter create . --project-name hostel_vaniya --org com.abuzarqasim --platforms android,web

# 2. Get packages
flutter pub get

# 3a. Test in Chrome
flutter run -d chrome

# 3b. Run on an Android phone (USB debugging on, phone plugged in)
flutter devices
flutter run -d <your-phone-id>

# 3c. Build an APK to install on any Android phone
flutter build apk --release
# -> build/app/outputs/flutter-apk/app-release.apk
```

Tip: in Chrome, open DevTools (F12) → device toolbar (Ctrl+Shift+M) and pick a phone size, since the app is designed for mobile screens.

**Trying the owner and admin screens:** on the Log in screen (debug builds only) there's a *Demo mode · log in as* picker. Choose Student, Hostel owner or Admin, then tap **Log in**. Sign-up with "Hostel owner" selected also goes to the owner app.

## Screens

| # | Screen | File |
|---|--------|------|
| **Auth** | | |
| 1 | Welcome | `features/auth/welcome_screen.dart` |
| 2 | Onboarding (3 slides) | `features/auth/onboarding_screen.dart` |
| 3 | Log in | `features/auth/login_screen.dart` |
| 4 | Create account (Student / Owner) | `features/auth/signup_screen.dart` |
| 5 | Verify number (OTP) | `features/auth/otp_screen.dart` |
| **Student** | | |
| 6 | Home | `features/student/student_home_screen.dart` |
| 7 | Search results | `features/student/search_results_screen.dart` |
| 8 | Filters | `features/student/filters_screen.dart` |
| 9 | Map | `features/student/map_screen.dart` |
| 10 | Hostel detail | `features/student/hostel_detail_screen.dart` |
| 11 | Rooms and rates | `features/student/rooms_rates_screen.dart` |
| 12 | Reviews | `features/student/reviews_screen.dart` |
| 13 | Compare hostels | `features/student/compare_screen.dart` |
| 14 | Saved hostels | `features/student/saved_screen.dart` |
| 15 | My visit requests | `features/student/visit_requests_screen.dart` |
| 16 | Profile | `features/student/student_profile_screen.dart` |
| **Hostel owner** | | |
| 17 | Dashboard | `features/owner/owner_dashboard_screen.dart` |
| 18 | My hostels | `features/owner/my_hostels_screen.dart` |
| 19 | Add / edit hostel | `features/owner/edit_hostel_screen.dart` |
| 20 | Manage rooms and rates | `features/owner/manage_rooms_screen.dart` |
| 21 | Visit requests | `features/owner/owner_requests_screen.dart` |
| 22 | Reviews (reply) | `features/owner/owner_reviews_screen.dart` |
| 23 | Verification | `features/owner/verification_screen.dart` |
| 24 | Profile | `features/owner/owner_profile_screen.dart` |
| **Admin** | | |
| 25 | Overview | `features/admin/admin_overview_screen.dart` |
| 26 | Approvals | `features/admin/approvals_screen.dart` |
| 27 | Hostels | `features/admin/admin_hostels_screen.dart` |
| 28 | Users | `features/admin/users_screen.dart` |
| 29 | Reports | `features/admin/reports_screen.dart` |
| 30 | Cities and universities | `features/admin/cities_screen.dart` |

Extra UI included: Request-a-visit sheet, Write-a-review sheet, Add/Edit room sheet, campus picker, confirm dialogs (log out, block user, reject listing, suspend).

## Project structure

```
lib/
  main.dart                  App entry, theme, routing
  core/
    theme/                   Colours, spacing/radius tokens, ThemeData + type scale
    routing/app_routes.dart  All named routes in one place
    utils/                   Formatters (Rs, km, initials) and form validators
  data/
    models.dart              Hostel, RoomType, Review, VisitRequest, AppUser …
    mock_data.dart           Sample data (replace with API calls)
    app_state.dart           Saved/compare selections and tab state (ValueNotifiers)
  widgets/                   Reusable UI: buttons, pills/badges, cards, shells, charts
  features/
    auth/  student/  owner/  admin/  shared/
assets/fonts/                Plus Jakarta Sans (OFL licence included)
```

## Design system

- **Themes**: Light, Dark and System (follows the phone). Users switch it in Profile → Appearance (admin: Settings menu; also on the Welcome screen). The choice is saved on the device (`shared_preferences`).
- **Colours** (`core/theme/app_colors.dart`): two palettes, `AppPalette.dark` and `AppPalette.light`. Dark: navy `#0D1323` background, lime `#C3F729`. Light: `#F4F6FA` background, white cards.
  - `AppColors.primary` = lime **fill** (buttons, selected pills, badges) with navy content on top.
  - `AppColors.accent` = brand colour for **text, icons and borders**: lime in dark, deep olive `#4F7A00` in light (lime text on white is unreadable).
  - Screens never hard-code colours; always use `AppColors.*` so both themes work.
- **Type**: Plus Jakarta Sans, bundled locally so it works offline. Scale in `AppText`.
- **Spacing**: 4-pt scale (`AppSpacing`), radii 8/12/16/20 (`AppRadius`).
- **Components**: always use the shared widgets (`AppButton`, `SelectPill`, `StatusBadge`, `SurfaceCard`, `StatCard` …) rather than styling inline, so the look stays consistent.

## UI practices followed

- One theme and token set. No hard-coded colours in screens.
- Touch targets 40 px or more; primary buttons 52 px.
- Tooltips/semantic labels on icon-only buttons; `Semantics` on pills, rating stars, charts and map pins.
- Text scaling respected (clamped to 0.9–1.3× so cards don't break).
- Empty states for every list, confirmation dialogs for destructive actions, snackbar feedback for every action.
- Form validation with clear messages (Pakistani mobile format, password length, required fields, terms).
- Tabs keep their scroll position (`IndexedStack`); Android back on a non-home tab returns to the first tab.

## Next steps (backend wiring)

- Replace `MockData` with a repository layer (e.g. Supabase/Firebase or a REST API).
- Call / WhatsApp buttons: add `url_launcher` and open `tel:` / `https://wa.me/92…` (see `features/student/widgets/contact_actions.dart`).
- Map: swap the illustrative `_MapCanvas` in `map_screen.dart` for `google_maps_flutter`; the pins and preview card overlays can stay.
- Photos: replace `PhotoPlaceholder` with `Image.network`/`cached_network_image`, and use `image_picker` on the edit-hostel and verification screens.
- Remove the debug-only demo role picker once real auth decides the role.
