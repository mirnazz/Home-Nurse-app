# Nurse UI & navigation changes — summary for Abeer

This note summarizes **Flutter UI and navigation work** on the **nurse** side of the app. It is meant to align frontend structure with what you will wire on the API later.

---

## What did **not** change (important)

- **`lib/Core/theme/api/api_service.dart`** and **`api_constants.dart`** were **not** modified for this work.
- **Nurse requests** still load and update through the same calls as before (`getNurseRequests`, accept/decline booking IDs, etc.).
- **Nurse availability** still uses the same availability endpoints inside `nurse_availability_screen.dart`.
- **Patient** appointment flows and shared models (`Appointment`, `AppointmentStatus`) are unchanged except where **list card presentation** was adjusted (see below).

When you add nurse appointments / bookings APIs, you will plug them in the same places described in **`ABEER_BACKEND_HANDOFF.md`** — this pass did not add or remove HTTP integration for those features.

---

## Nurse bottom navigation (4 tabs)

| Tab        | Screen / content |
|-----------|-------------------|
| **Home**  | Dashboard (`NurseHomeScreen` in `nurse_dashboard_screen.dart`) — quick actions, schedule preview, availability shortcut |
| **Schedule** | **`NurseScheduleScreen`** — two top-level segments: **Availability** \| **Appointments** |
| **Requests** | **`NurseRequestsScreen`** — service requests |
| **Profile** | **`NurseProfileScreen`** — settings hub (not the full editor) |

Removed from the bottom bar (by design): separate **Calendar**, **Appointments**, and **Transactions** items. Their **entry points** moved as below.

---

## Schedule (merged flow)

**File:** `lib/Features/Nurse/Presentation/nurse_schedule_screen.dart`

- Single **Schedule** area with tabs **Availability** and **Appointments**.
- **Availability** embeds `NurseAvailabilityScreen(embedded: true)` (same logic; layout tuned to match appointments).
- **Appointments** uses `NurseAppointmentsScreen(embedded: true)` with a **compact TabBar** for **Upcoming** vs **Past** (replaces the old large teal segment header on this screen only).

**Data today:** `NurseAppointmentsScreen` still uses **`mockAppointments`** when no list is injected — your API will replace that source later.

---

## Profile hub

**File:** `lib/Features/Nurse/nurse_profile_screen.dart`

- **Personal Info** → pushes **`NursePersonalInfoScreen`** (`nurse_personal_info_screen.dart`) — the former full-profile editor (forms, services, save).
- **Ratings** → **`NurseRatingsScreen`** — UI + placeholder/mock reviews only.
- **Earnings** → **`NurseEarningsScreen`** — placeholder copy (replaces old bottom-nav “Transactions” entry).
- **Logout** → clears token and returns to login (same pattern as patient).
- **Availability** was **removed** from this list; nurses open it from **Schedule → Availability** or home shortcuts.

---

## Nurse service requests

**Files:** `nurse_requests_screen.dart`, `nurse_service_request_models.dart`

- Tabs reduced to **Pending** and **Rejected** (rejected = declined/rejected from API mapping).
- **Accept** / **Reject** on the **card** (no separate details dialog).
- **`NurseRequestsFilter`** enum is now **`pending`** | **`rejected`** only.

---

## Appointment list cards (shared widget)

**File:** `lib/Core/widgets/appointment_list_card.dart`

- **Nurse list:** the large orange **“Waiting for Payment”** strip at the top of the card was **removed**; status is shown only via the **existing status chip** (e.g. “Waiting for Payment”, “Active / Paid”).
- **Patient list:** orange **pay** banner behavior is **unchanged** when payment is still due.
- Shared **schedule-style** card chrome (radius, padding, shadow) is centralized in **`appointment_ui_colors.dart`** (`scheduleCardDecoration`, etc.).

**Patient** appointments screen still uses **`AppointmentSegmentHeader`**; only the **nurse** appointments sub-tab uses the new compact tabs.

---

## Other files touched (UI / structure)

- **`nurse_dashboard_screen.dart`** — tab indices, quick actions (Schedule sub-tab indices), bottom nav items.
- **`nurse_availability_screen.dart`** — `embedded` mode for tabs; shared card styling when embedded; same API calls.
- **`nurse_appointments_screen.dart`** — nested `TabController` for Upcoming/Past; padding tokens.

**Removed:** duplicate/unused `nurse_request_details_sheet.dart` (was not imported).

---

## Suggested checklist for you (backend ↔ app)

1. **Nurse appointments:** expose list endpoint → map to `Appointment` / `AppointmentStatus` → replace `mockAppointments` in `NurseAppointmentsScreen` (optional `appointments` parameter already exists on the widget).
2. **Requests:** no contract change required for this UI pass; ensure accept/decline responses stay compatible with current `NurseServiceRequestItem.fromApiJson` mapping.
3. **Ratings / Earnings:** screens are placeholders until you define endpoints and fields.

---

## Questions

Coordinate with **Mirna** on any extra fields needed for the new card layout (e.g. duration on nurse list) or on keeping **patient** vs **nurse** list behavior aligned.

---

*Summary of nurse UI/navigation updates — no API file edits in this scope.*
