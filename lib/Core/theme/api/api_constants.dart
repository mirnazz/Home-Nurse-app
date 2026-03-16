class ApiConstants {
  static const String baseUrl = "http://localhost:5235";

  // =========================
  // Auth
  // =========================
  static const String login = "/api/Auth/login";
  static const String register = "/api/Auth/register";
  static const String forgotPassword = "/api/Auth/forgot-password";
  static const String resetPassword = "/api/Auth/reset-password";

  // =========================
  // Account
  // =========================
  static const String me = "/api/Account/me";

  // =========================
  // Nurse - Sprint 2
  // =========================

  // Personal information
  static const String nursePersonalInfo = "/api/Nurse/profile/personal-info";

  // Professional details
  static const String nurseProfessionalDetails =
      "/api/Nurse/profile/professional-details";

  // Nurse services
  static const String nurseServices = "/api/Nurse/services";

  // NEW: Service catalog
  static const String nurseServiceCatalog = "/api/Nurse/service-catalog";

  // Get full nurse profile
  static const String nurseProfile = "/api/Nurse/profile";

  // NEW: Update full profile multipart endpoint
  static const String nurseUpdateProfile = "/api/Nurse/update-profile";

  // =========================
  // Admin
  // =========================
  static const String pendingNurses = "/api/Admin/pending-nurses";
}
