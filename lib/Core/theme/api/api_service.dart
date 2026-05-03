import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'token_storage.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/models/notification_model.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_models.dart';

class ApiService {
  // =========================
  // Helpers
  // =========================

  static Future<String> _requireToken() async {
    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("User not logged in");
    }
    return token;
  }

  static String _extractErrorMessage(
    String body, {
    String fallback = "Request failed",
  }) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is String) return decoded;
      if (decoded is Map<String, dynamic>) {
        if (decoded["message"] != null) return decoded["message"].toString();
        if (decoded["title"] != null) return decoded["title"].toString();
        if (decoded["error"] != null) return decoded["error"].toString();
      }
    } catch (_) {}
    return body.isNotEmpty ? body : fallback;
  }

  static String _toIsoDateTime(String date) {
    return '${date}T00:00:00.000Z';
  }

  static Map<String, String> _jsonHeaders(String token) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  // =========================
  // Auth
  // =========================

static Future<void> registerPatient({
  required String fullName,
  required String email,
  required String password,
  required String phoneNumber,
}) async {
  final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.register);

 debugPrint("API REGISTER PHONE => $phoneNumber");
debugPrint("API REGISTER BODY => ${jsonEncode({
  "fullName": fullName,
  "email": email,
  "password": password,
  "phoneNumber": phoneNumber,
  "role": "Patient",
})}");

  final response = await http
      .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "password": password,
          "phoneNumber": phoneNumber,
          "role": "Patient",
        }),
      )
      .timeout(const Duration(seconds: 15));

  debugPrint("REGISTER STATUS => ${response.statusCode}");
  debugPrint("REGISTER BODY => ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(response.body, fallback: "Registration failed"),
    );
  }
}
  static Future<void> registerNurse({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.register);
    final response = await http
        .post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "fullName": fullName,
            "email": email,
            "password": password,
            "role": "Nurse",
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Registration failed"),
      );
    }
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);

    final response = await http
        .post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}),
        )
        .timeout(const Duration(seconds: 15));

    debugPrint("LOGIN STATUS => ${response.statusCode}");
    debugPrint("LOGIN BODY => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Invalid email or password",
        ),
      );
    }

    final data = jsonDecode(response.body);

    final token =
        data["token"] ?? data["accessToken"] ?? data["jwtToken"] ?? data["jwt"];

    if (token == null || token.toString().trim().isEmpty) {
      throw Exception("Login succeeded but token was not returned");
    }

    await TokenStorage.saveToken(token.toString());

    debugPrint("SAVED TOKEN => ${token.toString().substring(0, 20)}...");
  }

  static Future<String> forgotPassword({required String email}) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.forgotPassword);
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          _extractErrorMessage(
            response.body,
            fallback: "Forgot password failed",
          ),
        );
      }

      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('application/json')) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          if (data["message"] != null) return data["message"].toString();
          if (data["token"] != null)
            return "Reset token generated successfully.";
        }
      }
      return response.body.isNotEmpty
          ? response.body
          : "Check your email for reset instructions.";
    } on TimeoutException {
      throw Exception(
        "The server took too long to respond. Check backend/email settings and try again.",
      );
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  static Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.resetPassword);
    final response = await http
        .post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "token": token,
            "newPassword": newPassword,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Reset password failed"),
      );
    }
  }

  // =========================
  // Account
  // =========================

  static Future<Map<String, dynamic>> getMe() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.me);

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    debugPrint("GET ME URL => $url");
    debugPrint("GET ME STATUS => ${response.statusCode}");
    debugPrint("GET ME BODY => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Unauthorized");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final rawRole =
        data['role'] ??
        data['Role'] ??
        data['roleType'] ??
        data['RoleType'] ??
        (data['roles'] is List && data['roles'].isNotEmpty
            ? data['roles'][0]
            : null) ??
        (data['Roles'] is List && data['Roles'].isNotEmpty
            ? data['Roles'][0]
            : null) ??
        '';

    final role = rawRole.toString().trim();

    data['role_normalized'] = role;

    data['role_normalized'] = role;

    debugPrint("ROLE NORMALIZED => $role");

    return data;
  }

  static Future<Map<String, dynamic>> getAccount() async => getMe();

  // =========================
  // Patient Profile
  // =========================

  static Future<Map<String, dynamic>> getPatientProfile() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.patientProfile);

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load patient profile",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  static Future<void> updatePatientPersonalInfo({
    String? gender,
    DateTime? dateOfBirth,
    String? bloodType,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.patientProfilePersonalInfo,
    );

    final response = await http
        .put(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "gender": gender,
            "dateOfBirth": dateOfBirth?.toUtc().toIso8601String(),
            "bloodType": bloodType,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to update personal info",
        ),
      );
    }
  }

  static Future<void> updatePatientAddress({
    String? governorate,
    String? area,
    String? address,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.patientProfileAddress,
    );

    final response = await http
        .put(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "governorate": governorate,
            "area": area,
            "address": address,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to update address",
        ),
      );
    }
  }

  static Future<void> updatePatientMedicalInfo({
    String? conditions,
    String? allergies,
    String? notes,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.patientProfileMedicalInfo,
    );

    final response = await http
        .put(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "conditions": conditions,
            "allergies": allergies,
            "notes": notes,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to update medical info",
        ),
      );
    }
  }

  // =========================
  // Reviews
  // =========================

  static Future<PatientPendingReviewItem?> getPendingReview() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.reviewPending);

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load pending review",
        ),
      );
    }

    if (response.body.trim().isEmpty || response.body.trim() == 'null') {
      return null;
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) return null;

    final bookingId = (data['bookingId'] ?? '').toString();
    if (bookingId.isEmpty) return null;

    DateTime? completedAt;
    final rawDate = data['date']?.toString();
    if (rawDate != null && rawDate.isNotEmpty) {
      completedAt = DateTime.tryParse(rawDate);
    }

    return PatientPendingReviewItem(
      requestId: bookingId,
      appointmentId: bookingId,
      serviceName: (data['serviceName'] ?? '').toString(),
      nurseName: (data['nurseName'] ?? '').toString(),
      completedAt: completedAt,
    );
  }

  static Future<void> submitReview({
    required PatientRatingSubmissionDraft draft,
  }) async {
    final token = await _requireToken();
    final bookingId = int.tryParse(draft.bookingId);

    if (bookingId == null) {
      throw Exception("Invalid booking id for review submission");
    }

    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.reviewBase);

    final response = await http
        .post(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "bookingId": bookingId,
            "rating": draft.overallRating,
            "comment":
                draft.reviewText.trim().isEmpty
                    ? null
                    : draft.reviewText.trim(),
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to submit review",
        ),
      );
    }
  }

  static Future<void> dismissReviewPrompt({required String bookingId}) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.reviewBase}/$bookingId/dismiss",
    );

    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to dismiss review prompt",
        ),
      );
    }
  }

  static Future<void> remindReviewLater({required String bookingId}) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.reviewBase}/$bookingId/later",
    );

    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to postpone review prompt",
        ),
      );
    }
  }

  // =========================
  // Patient Dashboard
  // =========================

  static Future<Map<String, dynamic>> getPatientDashboardSummary() async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.patientDashboardSummary,
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load dashboard summary",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  // =========================
  // Nurse - Personal Info
  // =========================

  static Future<Map<String, dynamic>> getNursePersonalInfo() async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nursePersonalInfo,
    );
    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse personal info",
        ),
      );
    }
    return jsonDecode(response.body);
  }

  static Future<void> updateNursePersonalInfo({
    required String fullName,
    required String phoneNumber,
    required String location,
    required String address,
    required String bio,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nursePersonalInfo,
    );
    final response = await http
        .put(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "location": location,
            "address": address,
            "bio": bio,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to update personal info",
        ),
      );
    }
  }

  // =========================
  // Nurse - Professional Details
  // =========================

  static Future<Map<String, dynamic>> getNurseProfessionalDetails() async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nurseProfessionalDetails,
    );
    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse professional details",
        ),
      );
    }
    return jsonDecode(response.body);
  }

  static Future<void> updateNurseProfessionalDetails({
    required String licenseNumber,
    required String specialization,
    required int experienceYears,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nurseProfessionalDetails,
    );
    final response = await http
        .put(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "licenseNumber": licenseNumber,
            "specialization": specialization,
            "experienceYears": experienceYears,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to update professional details",
        ),
      );
    }
  }

  // =========================
  // Nurse - Full Profile
  // =========================

  static Future<Map<String, dynamic>> getNurseProfile() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseProfile);
    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse profile",
        ),
      );
    }
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateNurseProfileMultipart({
    required String phoneNumber,
    required String address,
    required String location,
    required String bio,
    required String licenseNumber,
    required String specialization,
    required int experienceYears,
    required String nationalId,
    File? profileImage,
    File? certificate,
    File? nationalIdImage,
  }) async {
    final token = await _requireToken();
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseUpdateProfile),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['address'] = address;
    request.fields['location'] = location;
    request.fields['bio'] = bio;
    request.fields['licenseNumber'] = licenseNumber;
    request.fields['specialization'] = specialization;
    request.fields['experienceYears'] = experienceYears.toString();
    request.fields['nationalId'] = nationalId;

    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profileImage', profileImage.path),
      );
    }
    if (certificate != null) {
      request.files.add(
        await http.MultipartFile.fromPath('certificate', certificate.path),
      );
    }
    if (nationalIdImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'nationalIdImage',
          nationalIdImage.path,
        ),
      );
    }

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to update nurse profile",
        ),
      );
    }

    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }

  // =========================
  // Nurse Services
  // =========================

  static Future<List<dynamic>> getServiceCatalog() async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nurseServiceCatalog,
    );
    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load service catalog",
        ),
      );
    }
    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  static Future<List<dynamic>> getNurseServices() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseServices);
    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse services",
        ),
      );
    }
    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  static Future<void> addNurseService({
    required int serviceCatalogId,
    required double price,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseServices);
    final response = await http
        .post(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "serviceCatalogId": serviceCatalogId,
            "price": price,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to add service"),
      );
    }
  }

  static Future<void> updateNurseService({
    required int id,
    required int serviceCatalogId,
    required double price,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseServices}/$id",
    );
    final response = await http
        .put(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "serviceCatalogId": serviceCatalogId,
            "price": price,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to update service",
        ),
      );
    }
  }

  static Future<void> deleteNurseService(int id) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseServices}/$id",
    );
    final response = await http
        .delete(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to delete service",
        ),
      );
    }
  }

  // =========================
  // Nurse Availability - Weekly
  // =========================

  static Future<List<dynamic>> getWeeklyAvailability() async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nurseWeeklyAvailability,
    );
    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load weekly availability",
        ),
      );
    }
    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  static Future<void> addWeeklyAvailability({
    required String dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nurseWeeklyAvailability,
    );
    final response = await http
        .post(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "dayOfWeek": dayOfWeek,
            "startTime": startTime,
            "endTime": endTime,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to add weekly availability",
        ),
      );
    }
  }

  static Future<void> deleteWeeklyAvailability(int id) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseWeeklyAvailability}/$id",
    );
    final response = await http
        .delete(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to delete weekly slot",
        ),
      );
    }
  }

  static Future<void> toggleWeeklyAvailability(int id) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseWeeklyToggle}/$id",
    );
    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to toggle slot status",
        ),
      );
    }
  }

  // =========================
  // Nurse Availability - Day
  // =========================

  static Future<Map<String, dynamic>> getDayAvailability({
    required String date,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseDayDetails}?date=${_toIsoDateTime(date)}",
    );
    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load day details",
        ),
      );
    }
    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : {};
  }

  static Future<void> overrideDayAvailability({
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseDayOverride);

    final start = startTime.length == 5 ? '$startTime:00' : startTime;
    final end = endTime.length == 5 ? '$endTime:00' : endTime;

    final response = await http
        .post(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "date": _toIsoDateTime(date),
            "startTime": start,
            "endTime": end,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to override day"),
      );
    }
  }

  static Future<void> blockDayAvailability({required String date}) async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseDayBlock);

    final response = await http
        .post(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({"date": _toIsoDateTime(date)}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to block day"),
      );
    }
  }

  static Future<void> unblockDayAvailability({required String date}) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseDayUnblock}?date=${_toIsoDateTime(date)}",
    );

    final response = await http
        .delete(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to unblock day"),
      );
    }
  }

  // =========================
  // Patient - Nurses / Booking
  // =========================

  static Future<Map<String, dynamic>> browseNurses({
    String? search,
    int? serviceCatalogId,
    String? location,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final token = await _requireToken();

      final queryParams = <String, String>{
        if (search != null && search.trim().isNotEmpty) "search": search.trim(),
        if (serviceCatalogId != null)
          "serviceCatalogId": serviceCatalogId.toString(),
        if (location != null && location.trim().isNotEmpty)
          "location": location.trim(),
        "pageNumber": pageNumber.toString(),
        "pageSize": pageSize.toString(),
      };

      final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.patientBrowseNurses}",
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: _jsonHeaders(token))
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data is Map<String, dynamic> ? data : {};
      } else {
        throw Exception(
          _extractErrorMessage(
            response.body,
            fallback: "Failed to browse nurses",
          ),
        );
      }
    } catch (e) {
      throw Exception(
        "Browse nurses error: ${e.toString().replaceFirst("Exception: ", "")}",
      );
    }
  }

  static Future<Map<String, dynamic>> getPatientNurseDetails({
    required String nurseId,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientNurseDetails}/$nurseId",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse details",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : {};
  }

  static Future<List<dynamic>> getPatientNurseServices({
    required String nurseId,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientNurseServices}/$nurseId/services",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse services",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  static Future<List<String>> getPatientAvailableSlots({
    required String nurseId,
    required int serviceId,
    required String date,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientAvailableSlots}/$nurseId/available-slots"
      "?serviceId=$serviceId&date=$date",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load available slots",
        ),
      );
    }

    final data = jsonDecode(response.body);
    if (data is! List) return [];
    return data.map((e) => e.toString()).toList();
  }

  static Future<Map<String, dynamic>> createBooking({
    required String nurseId,
    required int serviceId,
    required String date,
    required String startTime,
    required String serviceAddress,
    String? additionalNotes,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientBookings}",
    );

    final body = {
      "nurseId": nurseId,
      "serviceId": serviceId,
      "date": date,
      "startTime": startTime,
      "serviceAddress": serviceAddress,
      "additionalNotes": additionalNotes,
    };

    final response = await http.post(
      url,
      headers: _jsonHeaders(token),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to create booking",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  static Future<List<dynamic>> getPatientAvailableDates({
    required String nurseId,
    int daysAhead = 14,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientAvailableDates}/$nurseId/available-dates?daysAhead=$daysAhead",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load available dates",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  // =========================
  // Nurse Requests
  // =========================

  static Future<List<dynamic>> getNurseRequests({String? status}) async {
    final token = await _requireToken();

    final uri = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseRequests}",
    ).replace(queryParameters: status == null ? null : {"status": status});

    final response = await http
        .get(uri, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse requests",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  static Future<Map<String, dynamic>> getNurseRequestDetails({
    required int bookingId,
  }) async {
    final token = await _requireToken();

    final uri = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseRequests}/$bookingId",
    );

    final response = await http
        .get(uri, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load request details",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  static Future<void> acceptNurseRequest({required int bookingId}) async {
    final token = await _requireToken();

    final uri = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseRequests}/$bookingId/accept",
    );

    final response = await http
        .put(uri, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to accept request",
        ),
      );
    }
  }

  static Future<void> declineNurseRequest({required int bookingId}) async {
    final token = await _requireToken();

    final uri = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseRequests}/$bookingId/decline",
    );

    final response = await http
        .put(uri, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to decline request",
        ),
      );
    }
  }

  // =========================
  // Nurse Appointments
  // =========================
  static Future<void> completeNurseAppointment({
    required String bookingId,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseAppointments}/$bookingId/complete",
    );

    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to complete nurse appointment",
        ),
      );
    }
  }

  static Future<List<Appointment>> getNurseAppointments({
    required String tab,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseAppointments}?tab=$tab",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse appointments",
        ),
      );
    }

    final data = jsonDecode(response.body);
    if (data is! List) return [];

    return data
        .map<Appointment>(
          (item) => Appointment.fromNurseJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  static Future<Appointment> getNurseAppointmentDetails({
    required String bookingId,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseAppointments}/$bookingId",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load nurse appointment details",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return Appointment.fromNurseJson(data as Map<String, dynamic>);
  }

  static Future<void> cancelNurseAppointment({
    required String bookingId,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseAppointments}/$bookingId/cancel",
    );

    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to cancel nurse appointment",
        ),
      );
    }
  }

  // =========================
  // Patient - Appointments
  // =========================

  static Future<List<Appointment>> getPatientAppointments({
    required String tab,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientAppointments}?tab=$tab",
    );

    debugPrint("📡 PATIENT APPOINTMENTS URL => $url");

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    debugPrint("📥 STATUS => ${response.statusCode}");
    debugPrint("📥 BODY => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load appointments",
        ),
      );
    }

    final data = jsonDecode(response.body);

    if (data is! List) {
      debugPrint("❌ RESPONSE IS NOT LIST");
      return [];
    }

    final list =
        data
            .map<Appointment>(
              (item) =>
                  Appointment.fromPatientJson(item as Map<String, dynamic>),
            )
            .toList();

    // 🔥 أهم print
    for (var a in list) {
      debugPrint("🧾 APPOINTMENT => ID: ${a.id}, STATUS: ${a.status}");
    }

    return list;
  }

  static Future<void> cancelPatientAppointment({
    required String bookingId,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientAppointments}/$bookingId/cancel",
    );

    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to cancel appointment",
        ),
      );
    }
  }

  static Future<Appointment> getPatientAppointmentDetails({
    required String bookingId,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.patientAppointments}/$bookingId",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load appointment details",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return Appointment.fromPatientJson(data as Map<String, dynamic>);
  }

  // =========================
  // Payments
  // =========================

  static Future<Map<String, dynamic>> getPaymentSummary({
    required String bookingId,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.paymentSummary}?bookingId=$bookingId",
    );

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load payment summary",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  static Future<String> createPaymentIntent({required String bookingId}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}/api/Patient/payments/create-intent/$bookingId",
  );

  final response = await http
      .post(url, headers: _jsonHeaders(token))
      .timeout(const Duration(seconds: 20));

  debugPrint("CREATE INTENT URL => $url");
  debugPrint("CREATE INTENT STATUS => ${response.statusCode}");
  debugPrint("CREATE INTENT BODY => ${response.body}");

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to create payment intent",
      ),
    );
  }

  final data = jsonDecode(response.body);
  final secret = data["clientSecret"];

  if (secret == null || secret.toString().isEmpty) {
    throw Exception("Client secret was not returned by backend");
  }

  return secret.toString();
}
static Future<void> confirmPayment({
  required String bookingId,
  String? paymentIntentId,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}/api/Patient/payments/confirm/$bookingId",
  );

  final response = await http
      .post(url, headers: _jsonHeaders(token))
      .timeout(const Duration(seconds: 20));

  debugPrint("CONFIRM PAYMENT URL => $url");
  debugPrint("CONFIRM PAYMENT STATUS => ${response.statusCode}");
  debugPrint("CONFIRM PAYMENT BODY => ${response.body}");

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to confirm payment",
      ),
    );
  }
}
  // =========================
  // Notifications
  // =========================

  static Future<List<NotificationModel>> getNotifications() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.notifications);

    final response = await http
        .get(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to load notifications",
        ),
      );
    }

    final data = jsonDecode(response.body);
    if (data is! List) return [];

    return data
        .map<NotificationModel>(
          (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  static Future<void> markNotificationAsRead(dynamic notificationId) async {
    final token = await _requireToken();

    final id = notificationId.toString();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.notifications}/$id/read",
    );

    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to mark notification as read",
        ),
      );
    }
  }

  static Future<void> markAllNotificationsAsRead() async {
    final token = await _requireToken();

    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.notifications}/mark-all-read",
    );

    final response = await http
        .put(url, headers: _jsonHeaders(token))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to mark all notifications as read",
        ),
      );
    }
  }

  static Future<Map<String, dynamic>> submitProblem({
    required String category,
    required String subject,
    required String description,
    required bool isUrgent,
  }) async {
    final token = await _requireToken();

    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.submitProblem);

    debugPrint("SUBMIT PROBLEM URL => $url");
    debugPrint(
      "SUBMIT PROBLEM BODY => ${jsonEncode({"category": category, "subject": subject, "description": description, "isUrgent": isUrgent})}",
    );

    final response = await http
        .post(
          url,
          headers: _jsonHeaders(token),
          body: jsonEncode({
            "category": category,
            "subject": subject,
            "description": description,
            "isUrgent": isUrgent,
          }),
        )
        .timeout(const Duration(seconds: 15));

    debugPrint("SUBMIT PROBLEM STATUS => ${response.statusCode}");
    debugPrint("SUBMIT PROBLEM BODY RESPONSE => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to submit problem",
        ),
      );
    }

    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  static Future<List<dynamic>> getMyReports() async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.myReports),
      headers: _jsonHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load reports");
    }

    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>> getProblemDetails(int id) async {
    final token = await _requireToken();

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.problemDetails}/$id"),
      headers: _jsonHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load details");
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getNurseReviews() async {
  final token = await _requireToken();

  final url = Uri.parse("${ApiConstants.baseUrl}/api/Nurse/reviews");

  final response = await http
      .get(url, headers: _jsonHeaders(token))
      .timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception("Failed to load nurse reviews");
  }

  final data = jsonDecode(response.body);
  return data is Map<String, dynamic> ? data : <String, dynamic>{};
}

static Future<List<dynamic>> getPatientPaymentHistory() async {
  final token = await _requireToken();

  final url = Uri.parse("${ApiConstants.baseUrl}/api/patient/payments/history");

  final response = await http
      .get(url, headers: _jsonHeaders(token))
      .timeout(const Duration(seconds: 15));

  debugPrint("PAYMENT HISTORY URL => $url");
  debugPrint("PAYMENT HISTORY STATUS => ${response.statusCode}");
  debugPrint("PAYMENT HISTORY BODY => ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to load payment history",
      ),
    );
  }

  final data = jsonDecode(response.body);
  return data is List ? data : [];
}
static Future<Map<String, dynamic>> submitPatientIssue({
  required String category,
  required String subject,
  required String description,
  required bool isUrgent,
}) async {
  final token = await _requireToken();

  final url = Uri.parse("${ApiConstants.baseUrl}/api/patient/issues");

  final response = await http
      .post(
        url,
        headers: _jsonHeaders(token),
        body: jsonEncode({
          "category": category,
          "subject": subject,
          "description": description,
          "isUrgent": isUrgent,
        }),
      )
      .timeout(const Duration(seconds: 15));

  debugPrint("SUBMIT PATIENT ISSUE STATUS => ${response.statusCode}");
  debugPrint("SUBMIT PATIENT ISSUE BODY => ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to submit issue",
      ),
    );
  }

  final data = jsonDecode(response.body);
  return data is Map<String, dynamic> ? data : <String, dynamic>{};
}
static Future<Map<String, dynamic>> getNursePaymentSummary() async {
  final token = await _requireToken();

  final url = Uri.parse("${ApiConstants.baseUrl}/api/nurse/payments/summary");

  final response = await http
      .get(url, headers: _jsonHeaders(token))
      .timeout(const Duration(seconds: 15));

  debugPrint("NURSE PAYMENT SUMMARY STATUS => ${response.statusCode}");
  debugPrint("NURSE PAYMENT SUMMARY BODY => ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to load earnings summary",
      ),
    );
  }

  final data = jsonDecode(response.body);
  return data is Map<String, dynamic> ? data : <String, dynamic>{};
}

static Future<List<dynamic>> getNursePaymentHistory({
  required String tab,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}/api/nurse/payments/history?tab=$tab",
  );

  final response = await http
      .get(url, headers: _jsonHeaders(token))
      .timeout(const Duration(seconds: 15));

  debugPrint("NURSE PAYMENT HISTORY URL => $url");
  debugPrint("NURSE PAYMENT HISTORY STATUS => ${response.statusCode}");
  debugPrint("NURSE PAYMENT HISTORY BODY => ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to load earnings history",
      ),
    );
  }

  final data = jsonDecode(response.body);
  return data is List ? data : [];
}
}
