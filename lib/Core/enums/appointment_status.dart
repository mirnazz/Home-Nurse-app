/// Shared appointment lifecycle for Patient & Nurse UIs.
///
/// **Patient dashboard (UI grouping):**
/// - Upcoming: [pending], [confirmed] / [waitingPayment] (nurse accepted, pay to activate),
///   [rejected], [paid] (Active/Paid).
/// - Past: [cancelled], [completed].
///
/// TODO(backend): Align with API enum / int codes when integrating.
enum AppointmentStatus {
  pending,
  confirmed,
  waitingPayment,
  paid,
  completed,
  cancelled,
  rejected,
}
