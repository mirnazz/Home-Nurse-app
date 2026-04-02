# New added — Patient profile & review (Flutter)

Short summary of what was added for handoff (e.g. API integration).

---

## Patient profile

**Where:** `lib/Features/Patients/Presentation/patient_profile_screen.dart`  
**Entry:** More tab → Profile (`patient_more_screen.dart` → `PatientProfileScreen`).

**What it does**

- Scrollable profile with sections: header (avatar, name, phone), personal info, address, medical (conditions with exclusive “None”, allergy chips + free text, notes).
- **View mode** by default (read-only). **Edit profile** → editable fields → **Save** / **Cancel** (cancel restores snapshot from when edit started).
- **No mock data:** fields start empty; empty values show as “—”. State is local only.
- Styling aligns with patient onboarding (teal primary, white cards, `patientOnboardingOutlineDecoration` where relevant). Governorate uses shared `PatientOnboardingStyledDropdown` (`patient_onboarding_styled_dropdown.dart`).

**Backend (to wire later)**

- **GET** → hydrate `PatientProfileLocalModel` (or equivalent) when opening the screen or on load.
- **PUT** → send updated model on **Save** (replace local snackbar / add error handling as needed).

---

## Review flow & models

**UI:** `lib/Features/Patients/Presentation/patient_review_dialog.dart`  
**Types:** `lib/Features/Patients/Presentation/patient_review_models.dart`

**What it does**

- **Blocking modal** (`showPatientReviewModal`): not dismissible by tapping outside; back is blocked until the user picks an action.
- Header: title “Rate Your Experience”, service name, nurse name, **X** (dismiss without submitting).
- **Overall** 5-star rating (required to submit). Four areas: Professionalism, Punctuality, Communication, Service Quality.
- Optional text, **max 500** characters.
- **Submit review** → builds `PatientRatingSubmissionDraft` and closes with result **submitted**.
- **Later** → closes with **later** (prompt can show again; first item may be deferred for the current app session in home logic).
- **X** → **dismissedForever** for that request (removed from local pending list only; no API).

**Models (review)**

| Type | Role |
|------|------|
| `PatientPendingReviewItem` | One booking that needs a review (`requestId`, `appointmentId`, `serviceName`, `nurseName`, `completedAt`). |
| `PatientRatingSubmissionDraft` | Payload from the modal; includes star fields + `reviewText`; **`toJson()`** ready for POST. |
| `PatientReviewModalAction` | `submitted` / `later` / `dismissedForever`. |
| `PatientReviewDialogResult` | Factory helpers: `.submitted(draft)`, `.later()`, `.dismissedForever()`. |

**Home shell:** `patient_home_screen.dart`

- Optional **`onFetchPendingReviewRequests`** → replaces local preview list when implemented.
- Optional **`onSubmitReview(draft)`** → call API on successful submit.
- After fetch (or preview), can **auto-open** the modal for the next pending item until the user submits, defers with Later, or dismisses with X.

**Backend (to wire later)**

- Expose **pending reviews** for the patient; map rows to `PatientPendingReviewItem`.
- **POST** review using `PatientRatingSubmissionDraft.toJson()` (or your contract).
- Remove or hide completed items from pending after successful submit (server + refetch if needed).

---

## Files to know

| Area | Main files |
|------|------------|
| Profile | `patient_profile_screen.dart`, `patient_more_screen.dart` |
| Review UI | `patient_review_dialog.dart` |
| Review data | `patient_review_models.dart` |
| Home + prompt | `patient_home_screen.dart` |
