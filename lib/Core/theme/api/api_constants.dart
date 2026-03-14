class ApiConstants {
  static const String baseUrl = "http://172.20.10.10:5235";

  // Auth
  static const String login = "/api/Auth/login";
  static const String register = "/api/Auth/register";
  static const String forgotPassword = "/api/Auth/forgot-password";
  static const String resetPassword = "/api/Auth/reset-password";

  // Nurse
  static const String nurseUpdateProfile = "/api/Nurse/update-profile";

  // Account
  static const String me = "/api/Account/me";
}
