# Localization & UI language handoff (for Abeer)

This branch adds **Arabic / English UI localization** and a **frontend-only** language preference flow. It is intended to sit on top of **sprint-5** without changing backend contracts, API payloads, or integration logic.

---

## What was intentionally **not** included in this push

To keep your dependency graph identical to **sprint-5** on your machine:

| Item | Reason |
|------|--------|
| `pubspec.yaml` | Excluded from commit so your local `intl`, `flutter_stripe`, and other versions stay as you pulled them. |
| `pubspec.lock` | Same as above; avoids lockfile drift when merging. |

**After you pull this branch**, run your usual:

```bash
flutter pub get
flutter gen-l10n
```

If anything fails to resolve, compare only the **localization-related** bits from our side (e.g. `flutter_localizations`, `generate: true`, `shared_preferences`) against your current `pubspec.yaml` and merge manually if needed.

---

## Backend / API safety (explicit guarantee)

- **`lib/Core/theme/api/`** (including `api_service.dart`, `token_storage.dart`) was **not modified** in this work.
- **`lib/Core/models/`** was **not modified**.
- **`lib/Features/Patients/Presentation/payment_screen.dart`** matches **origin/sprint-5** (Stripe + `ApiService.createPaymentIntent` / `confirmPayment` flow preserved).
- Changes are limited to:
  - **UI strings** → `AppLocalizations` / ARB keys
  - **Locale & RTL** → `MaterialApp.locale`, delegates, `AppLocaleScope`
  - **Local preference only** → `SharedPreferences` key `app_language` (`en` | `ar`)

No request URLs, headers, JSON shapes, or repository/service method signatures were changed for integration purposes.

---

## How `main.dart` relates to your original sprint-5 file

Your sprint-5 `main.dart` already had:

- `flutter_stripe` import and `Stripe.publishableKey` + `applySettings()`
- `SplashScreen` as initial `home`
- Named routes for login, dashboards, etc.

This branch **keeps all of that** and **adds**:

- Load saved language before `runApp` via `AppLanguagePrefs.getLanguage()` (default `en`).
- `NurseApp` as `StatefulWidget` with `AppLocaleScope` so the UI can switch language at runtime.
- `AppLocalizations` delegates / `supportedLocales` on `MaterialApp`.
- Extra route: `"/notifications"` → notifications screen (UI entry only).

Stripe initialization remains **active** with the same publishable key pattern as sprint-5.

---

## New / important files (localization plumbing)

| Path | Purpose |
|------|---------|
| `l10n.yaml` | Configures Flutter `gen-l10n` for this project. |
| `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb` | All user-facing strings (and placeholders). |
| `lib/app_locale_scope.dart` | Inherited widget: exposes `setLocale` for runtime switching. |
| `lib/Core/localization/app_language_prefs.dart` | `SharedPreferences` read/write for `app_language`. |
| `lib/Core/widgets/language_selector_sheet.dart` | Shared bottom sheet: English / العربية + checkmark; saves + applies locale. |

Generated code lives in the repo under `lib/l10n/` and is imported as `package:nurse_app/l10n/app_localizations.dart` (non-synthetic `gen-l10n`; see `l10n.yaml` with `synthetic-package: false` and `output-dir: lib/l10n`).

**Commit these generated files** (they are real sources, not `package:flutter_gen`):

- `lib/l10n/app_localizations.dart`
- `lib/l10n/app_localizations_en.dart`
- `lib/l10n/app_localizations_ar.dart`

Whenever you change ARBs, run `flutter gen-l10n` again and commit the updated generated files so teammates and CI do not depend on the deprecated synthetic package.

---

## Where users change language

- **Login**: language icon opens the bottom sheet; choice is saved and applied immediately.
- **Nurse home header**: language icon → same sheet.
- **Patient home header**: language icon → same sheet.
- **Patient “More” tab**: language list (unchanged UX; now also persists preference).
- **Nurse profile (More tab)**: language row opens the same sheet.

---

## Screens / areas touched (high level)

Roughly **40+** Dart files under `lib/` plus ARBs: nurse and patient flows, shared widgets (status chips, banners, appointment cards), auth (login, signup, forgot password), notifications, verification resubmission, onboarding dropdown styling, etc. All edits are **string / formatting-for-locale** where possible (e.g. `DateFormat` with locale tag), not API logic.

---

## Stripe / IDE warnings

If `flutter_stripe` is commented out or version-mismatched in **your** `pubspec.yaml`, you may see analyzer/IDE red underlines in files that import Stripe. That is expected until dependencies align; **payment_screen.dart** integration with the backend was left as in sprint-5.

---

## Verification commands (for you or CI)

```bash
git diff origin/sprint-5 -- lib/Core/theme/api lib/Core/models
# Expect: no output

git diff origin/sprint-5 -- lib/Features/Patients/Presentation/payment_screen.dart
# Expect: no output

flutter analyze
flutter gen-l10n
```

---

## Branch name

Recommended branch for this work: **`feature/ui-localization-ar-en`** (created from current sprint-5-based state).

---

## Contact / merge note

When merging into `sprint-5`, resolve **only** `pubspec.yaml` / `pubspec.lock` on your side if needed; the rest should merge as UI + l10n + small `main.dart` extension.

Thank you for the backend integration work on sprint-5 — this layer stays strictly on the presentation and localization side.
