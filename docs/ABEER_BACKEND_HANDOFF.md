# Backend & API handoff — Abeer Qishawi

This document describes **appointment and booking flows** implemented in the Flutter app (UI + mock data), how **patient** and **nurse** experiences differ, and **what you need to implement or expose on the backend** so we can replace mocks with real APIs.

---

## Table of contents

1. [What was built (summary)](#1-what-was-built-summary)
2. [Shared concepts](#2-shared-concepts)
3. [Patient flow](#3-patient-flow)
4. [Nurse flow](#4-nurse-flow)
5. [Nurse requests vs appointments](#5-nurse-requests-vs-appointments)
6. [Contact: Call & WhatsApp](#6-contact-call--whatsapp)
7. [Key files (create / touch)](#7-key-files-create--touch)
8. [Your checklist (backend + Flutter wiring)](#8-your-checklist-backend--flutter-wiring)
9. [Suggested API shape (reference)](#9-suggested-api-shape-reference)

---

## 1. What was built (summary)

- **Appointments UI** for **Patient** and **Nurse**: lists (Upcoming / Past), cards, detail screens, status chips, payment banners where needed.
- **Shared Dart model** `Appointment` and enum `AppointmentStatus` — used everywhere until API DTOs replace mock lists.
- **`mockAppointments`** in `lib/Core/data/mock_appointments.dart` — **replace with API** when endpoints exist.
- **Patient** appointment details: structured cards (Status, Nurse info, Appointment details, Total cost), **Call + WhatsApp** for nurse phone, pay/cancel stubs.
- **Nurse** appointment details: Patient info with **Call Patient + Message on WhatsApp**, action stubs (cancel, mark complete).
- **Nurse Requests** (separate feature): list + dialog for accept/decline — also **TODO** for your endpoints.
- **`ApiService` / `ApiConstants`** — auth, account, nurse profile, nurse services exist; **no appointment/booking endpoints yet**.

---

## 2. Shared concepts

### `AppointmentStatus` (`lib/Core/enums/appointment_status.dart`)

| Enum value          | Intended meaning |
|---------------------|------------------|
| `pending`           | Booking sent; nurse has not accepted/rejected. |
| `confirmed`         | Nurse accepted; patient may still need to pay (unpaid confirmed slot). |
| `waitingPayment`    | Same **patient-facing** idea as confirmed in UI; can be a distinct backend state for “nurse accepted, awaiting payment”. |
| `paid`              | Payment completed → shown as **Active/Paid** to patient. |
| `rejected`          | Nurse declined. |
| `cancelled`         | Booking cancelled. |
| `completed`         | Service/visit finished. |

**Important:** The app assumes you will either **align API status values** with this enum (via mapping) or we extend the enum / mapper once your contract is fixed.

### `Appointment` model (`lib/Core/models/appointment.dart`)

Fields used by UI:

| Field | Notes |
|-------|--------|
| `id` | String — booking id from API. |
| `patientName`, `nurseName` | Display names. |
| `serviceName` | Booked service. |
| `dateTime`, `location` | Schedule + address. |
| `status` | `AppointmentStatus`. |
| `price` | JOD (double). |
| `durationMinutes` | Optional — hides duration line if null. |
| `patientPhone` | For **nurse** Call/WhatsApp. |
| `nursePhone` | For **patient** Call/WhatsApp. |
| `nurseSpecialty` | Optional; falls back to `serviceName` if null. |

**Your job:** Return these (or equivalent) in JSON and map in a small `Appointment.fromJson` (or repository) layer.

---

## 3. Patient flow

### List screen — `PatientAppointmentsScreen`

- **Upcoming** includes: `pending`, `confirmed`, `waitingPayment`, `paid`, **`rejected`** (rejected stays under Upcoming, **not** Past).
- **Past** includes only: **`completed`**, **`cancelled`**.

### Chips & banners (`lib/Core/widgets/patient_appointment_status_ui.dart` + list card)

- `confirmed` **and** `waitingPayment` → patient sees chip **“Confirmed”** (green) + orange **pay banner** when payment still due (`patientAppointmentShowsPaymentBanner`).
- `paid` → **“Active/Paid”**.
- `pending` → **“Pending”**.
- `rejected` → red **“Rejected”**.
- Past: **Cancelled** / **Completed** styling.

### Detail screen — `patient_appointment_details_screen.dart`

- Cards: **Status** → **Nurse Information** (avatar, name, specialty, phone, **Call + WhatsApp**) → **Appointment details** (date, time & duration, address) → optional **Pay to continue** banner → **Total cost** + payment pill (e.g. UNPAID / PAID / AWAITING NURSE).
- Bottom actions: **Pay now** + **Cancel** when applicable (stubs); **no** separate “contact nurse” button — contact is only via nurse row.

### What you wire

- `GET` patient appointments (or one list + app filters by status).
- **Pay** endpoint (or payment provider webhook → status → `paid`).
- **Cancel** (patient), with valid state transitions.
- Ensure **`nursePhone`** (and optional **`nurseSpecialty`**) are in the payload for contact UI.

---

## 4. Nurse flow

### List screen — `NurseAppointmentsScreen`

Nurse **appointment** list is intentionally **narrow**:

- **Upcoming:** only `waitingPayment`, `paid` (no `pending` / `confirmed` / `rejected` here — those belong to **Requests**).
- **Past:** `completed`, `cancelled`.

### Chips — `lib/Core/widgets/nurse_appointment_chip_style.dart`

- **Waiting for Payment**, **Active / Paid**, **Completed**, **Cancelled** (+ fallback for unexpected status).

### Detail screen — `nurse_appointment_details_screen.dart`

- **Patient Information:** avatar, name, service, phone, **Call Patient** + **Message on WhatsApp** (same row pattern as patient).
- Actions: e.g. cancel, mark complete — **SnackBar stubs** today.

### What you wire

- `GET` nurse appointments for logged-in nurse.
- **Mark complete**, **cancel** (if allowed), consistent with your rules.
- Ensure **`patientPhone`** is returned for Call/WhatsApp.

---

## 5. Nurse requests vs appointments

| Area | Purpose |
|------|--------|
| **Nurse Requests** (`nurse_requests_screen.dart`, `nurse_request_details_sheet.dart`, `nurse_service_request_models.dart`) | Incoming jobs: **Pending / Accepted / Declined** at *request* level. Accept/decline → should create/update **appointment** + `AppointmentStatus` on backend. |
| **Nurse Appointments** | After acceptance + payment flow, **scheduled** items: waiting payment, active/paid, then completed/cancelled. |

Code comments marked **`TODO(Abeer):`** point to where to plug **fetch / accept / decline** for requests.

---

## 6. Contact: Call & WhatsApp

- Implementation: `lib/Core/utils/contact_launch.dart`
- **Call:** dialog shows the number, then opens system dialer (`tel:`).
- **WhatsApp:** `https://wa.me/<digits>` via `url_launcher`.
- **Android:** `AndroidManifest.xml` includes `<queries>` for `tel` and `wa.me`.
- **iOS:** `Info.plist` includes `LSApplicationQueriesSchemes` (`tel`, `https`, `whatsapp`).

No backend required for opening dialer/WhatsApp — only that **phone fields** in API responses are correct (E.164 or consistent format for `wa.me`).

---

## 7. Key files (create / touch)

### Core — appointments

| Path | Role |
|------|------|
| `lib/Core/enums/appointment_status.dart` | Shared status enum + doc for patient tab grouping. |
| `lib/Core/models/appointment.dart` | UI model; add `fromJson` when API ready. |
| `lib/Core/data/mock_appointments.dart` | **Replace** with repository/API. |
| `lib/Core/theme/appointment_ui_colors.dart` | Teal, greys, orange banner. |
| `lib/Core/widgets/appointment_list_card.dart` | List card; patient vs nurse chip/banner. |
| `lib/Core/widgets/appointment_detail_row.dart` | Grey rows with teal icons. |
| `lib/Core/widgets/appointment_segment_header.dart` | Upcoming / Past toggle. |
| `lib/Core/widgets/patient_appointment_status_ui.dart` | Patient chip rules + pay banner flag. |
| `lib/Core/widgets/nurse_appointment_chip_style.dart` | Nurse status chips (4 states). |
| `lib/Core/widgets/status_chip.dart` | Generic chip (optional reuse). |
| `lib/Core/utils/contact_launch.dart` | Call dialog + WhatsApp + `AppointmentCallWhatsAppRow`. |

### Features — Patient

| Path | Role |
|------|------|
| `lib/Features/Patients/Presentation/patient_appointments_screen.dart` | List + tabs; inject `appointments` from parent when API exists. |
| `lib/Features/Patients/Presentation/patient_appointment_details_screen.dart` | Full patient details layout + actions. |

### Features — Nurse

| Path | Role |
|------|------|
| `lib/Features/Nurse/Presentation/nurse_appointments_screen.dart` | Nurse list + tabs. |
| `lib/Features/Nurse/Presentation/nurse_appointment_details_screen.dart` | Nurse details + patient contact row. |
| `lib/Features/Nurse/Presentation/nurse_requests_screen.dart` | Requests list; `TODO(Abeer)` for API. |
| `lib/Features/Nurse/Presentation/nurse_request_details_sheet.dart` | Accept/decline dialog UI. |
| `lib/Features/Nurse/Presentation/nurse_service_request_models.dart` | Request item model. |

### API (existing — extend)

| Path | Role |
|------|------|
| `lib/Core/theme/api/api_constants.dart` | Add booking/appointment paths here. |
| `lib/Core/theme/api/api_service.dart` | Add authenticated GET/POST/PUT for bookings. |

### Platform

| Path | Role |
|------|------|
| `pubspec.yaml` | `url_launcher` dependency. |
| `android/app/src/main/AndroidManifest.xml` | Intent queries for `tel`, `wa.me`. |
| `ios/Runner/Info.plist` | `LSApplicationQueriesSchemes`. |

---

## 8. Your checklist (backend + Flutter wiring)

### Backend

1. Design **booking/appointment** entity and **state machine** (who can transition what).
2. Expose **Patient** endpoints: list (and optional detail), pay, cancel.
3. Expose **Nurse** endpoints: list appointments, mark complete, cancel (if allowed).
4. Expose **Nurse request** endpoints: list, accept, decline — and define how that creates/updates an **appointment** + status.
5. Return **phones** and any **specialty** needed for UI.
6. Document **status enum** (string or int) ↔ `AppointmentStatus` mapping for Mirna / frontend.

### Flutter (can be you or Mirna)

1. Add constants + `ApiService` methods.
2. Implement **`Appointment.fromJson`** (and error handling).
3. Replace `mockAppointments` usage with **repository** that calls API.
4. Replace **SnackBar** stubs: Pay, Cancel, Mark complete, Accept/Decline request.
5. Pass **`List<Appointment>?`** from a parent that loads after login (or use state management).

---

## 9. Suggested API shape (reference)

Not prescriptive — align with your .NET (or other) API style.

**Patient**

- `GET /api/Patient/appointments` or `/api/Bookings?role=patient`
- `POST /api/Bookings/{id}/pay` (or payment session)
- `POST /api/Bookings/{id}/cancel`

**Nurse**

- `GET /api/Nurse/appointments`
- `POST /api/Nurse/appointments/{id}/complete`
- `POST /api/Nurse/appointments/{id}/cancel`

**Nurse requests**

- `GET /api/Nurse/requests`
- `POST /api/Nurse/requests/{id}/accept`
- `POST /api/Nurse/requests/{id}/decline`

**Response fields (minimum)**  
`id`, `patientName`, `nurseName`, `serviceName`, `scheduledAt` (ISO 8601), `address`/`location`, `status`, `price`, `durationMinutes`, `patientPhone`, `nursePhone`, `nurseSpecialty` (optional).

---

## Questions?

Coordinate with **Mirna** on enum naming and JSON field names so mappers stay in one place (e.g. `lib/Core/data/appointment_dto.dart` or inside `ApiService`).

---

*Generated for Nurse Home App — appointment & booking handoff.*
