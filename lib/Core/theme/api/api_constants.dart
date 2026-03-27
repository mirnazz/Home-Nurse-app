class ApiConstants {
  // =========================
  // Base
  // =========================
static const String baseUrl = "http://172.20.10.6:5235";

  // =========================
  // Auth
  // =========================
  static const String login = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String forgotPassword = "/api/auth/forgot-password";
  static const String resetPassword = "/api/auth/reset-password";

  // =========================
  // Account
  // =========================
  static const String me = "/api/account/me";

  // =========================
  // Nurse - Profile
  // =========================
  static const String nurseProfileBase = "/api/nurse";

  static const String nursePersonalInfo =
      "$nurseProfileBase/profile/personal-info";

  static const String nurseProfessionalDetails =
      "$nurseProfileBase/profile/professional-details";

  static const String nurseServices =
      "$nurseProfileBase/services";

  static const String nurseServiceCatalog =
      "$nurseProfileBase/service-catalog";

  static const String nurseProfile =
      "$nurseProfileBase/profile";

  static const String nurseUpdateProfile =
      "$nurseProfileBase/update-profile";

  // =========================
  // Nurse Availability
  // =========================
  static const String nurseWeeklyAvailability =
      "$nurseProfileBase/weekly-availability";

  static const String nurseWeeklyToggle =
      "$nurseProfileBase/availability/weekly/toggle";

  static const String nurseDayDetails =
      "$nurseProfileBase/availability/day-details";

  static const String nurseDayOverride =
      "$nurseProfileBase/availability/override";

  static const String nurseDayBlock =
      "$nurseProfileBase/availability/block-day";

  static const String nurseDayUnblock =
      "$nurseProfileBase/availability/override";

  // =========================
  // Patient - Nurses
  // =========================
  static const String patientBase = "/api/patient";

  static const String patientBrowseNurses =
      "$patientBase/nurses/browse";

  static const String patientNurseDetails =
      "$patientBase/nurses";
  // usage: /api/patient/nurses/{nurseId}

  static const String patientNurseServices =
      "$patientBase/nurses";
  // usage: /api/patient/nurses/{nurseId}/services

  static const String patientAvailableDates =
      "$patientBase/nurses";
  // usage: /api/patient/nurses/{nurseId}/available-dates

  static const String patientAvailableSlots =
      "$patientBase/nurses";
  // usage: /api/patient/nurses/{nurseId}/available-slots
  static const String nurseAppointments = "$nurseProfileBase/appointments";

  // =========================
  // Patient - Bookings
  // =========================
  static const String patientBookings =
      "$patientBase/bookings";

  // =========================
  // Admin
  // =========================
  static const String pendingNurses =
      "/api/admin/pending-nurses";
      static const String nurseRequests = "$nurseProfileBase/requests";
      static const String patientAppointments = '/api/patient/appointments';


  static const String paymentSummary = '/api/patient/payments/summary';
  static const String createPaymentIntent = '/api/patient/payments/create-intent';
  static const String confirmPayment = '/api/patient/payments/confirm';
      
}
