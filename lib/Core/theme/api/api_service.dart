import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'token_storage.dart';
import 'package:nurse_app/Core/models/appointment.dart';
import 'package:nurse_app/Core/models/notification_model.dart';

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

  // FIX: Backend expects full ISO 8601 DateTime string for DateTime fields
  // "2026-03-18" → "2026-03-18T00:00:00.000Z"
  static String _toIsoDateTime(String date) {
    return '${date}T00:00:00.000Z';
  }

  // =========================
  // Auth
  // =========================

  static Future<void> registerPatient({
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
            "role": "Patient",
          }),
        )
        .timeout(const Duration(seconds: 15));

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

    if (response.statusCode != 200) {
      throw Exception("Invalid email or password");
    }

    final data = jsonDecode(response.body);
    await TokenStorage.saveToken(data['token']);
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
          _extractErrorMessage(response.body, fallback: "Forgot password failed"),
        );
      }

      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('application/json')) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          if (data["message"] != null) return data["message"].toString();
          if (data["token"] != null) return "Reset token generated successfully.";
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
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) throw Exception("Unauthorized");
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAccount() async => getMe();

  // =========================
  // Nurse - Personal Info
  // =========================

  static Future<Map<String, dynamic>> getNursePersonalInfo() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nursePersonalInfo);
    final response = await http
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load nurse personal info"),
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
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nursePersonalInfo);
    final response = await http
        .put(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
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
        _extractErrorMessage(response.body, fallback: "Failed to update personal info"),
      );
    }
  }

  // =========================
  // Nurse - Professional Details
  // =========================

  static Future<Map<String, dynamic>> getNurseProfessionalDetails() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseProfessionalDetails);
    final response = await http
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load nurse professional details"),
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
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseProfessionalDetails);
    final response = await http
        .put(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "licenseNumber": licenseNumber,
            "specialization": specialization,
            "experienceYears": experienceYears,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to update professional details"),
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
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load nurse profile"),
      );
    }
    return jsonDecode(response.body);
  }

  // =========================
  // Nurse - Update Full Profile (multipart)
  // =========================

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
        await http.MultipartFile.fromPath('nationalIdImage', nationalIdImage.path),
      );
    }

    final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to update nurse profile"),
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
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseServiceCatalog);
    final response = await http
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load service catalog"),
      );
    }
    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  static Future<List<dynamic>> getNurseServices() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseServices);
    final response = await http
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load nurse services"),
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
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"serviceCatalogId": serviceCatalogId, "price": price}),
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
    final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.nurseServices}/$id");
    final response = await http
        .put(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"serviceCatalogId": serviceCatalogId, "price": price}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to update service"),
      );
    }
  }

  static Future<void> deleteNurseService(int id) async {
    final token = await _requireToken();
    final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.nurseServices}/$id");
    final response = await http
        .delete(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to delete service"),
      );
    }
  }

  // =========================
  // Nurse Availability - Weekly
  // =========================

  static Future<List<dynamic>> getWeeklyAvailability() async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseWeeklyAvailability);
    final response = await http
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load weekly availability"),
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
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseWeeklyAvailability);
    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "dayOfWeek": dayOfWeek,
            "startTime": startTime,
            "endTime": endTime,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to add weekly availability"),
      );
    }
  }

  static Future<void> deleteWeeklyAvailability(int id) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseWeeklyAvailability}/$id",
    );
    final response = await http
        .delete(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to delete weekly slot"),
      );
    }
  }

  static Future<void> toggleWeeklyAvailability(int id) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseWeeklyToggle}/$id",
    );
    final response = await http
        .put(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to toggle slot status"),
      );
    }
  }

  // =========================
  // Nurse Availability - Day
  // =========================

  // FIX: correct endpoint is /api/Nurse/availability/day-details
  // backend returns: selectedDate, dayOfWeek, defaultWorkingHours, dayOverride, bookedAppointments
  static Future<Map<String, dynamic>> getDayAvailability({
    required String date,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseDayDetails}?date=${_toIsoDateTime(date)}",
    );
    final response = await http
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load day details"),
      );
    }
    final data = jsonDecode(response.body);
    return data is Map<String, dynamic> ? data : {};
  }

  // FIX: POST /api/Nurse/availability/override
  // Body: { date: ISO string, startTime: "HH:mm:ss", endTime: "HH:mm:ss" }
  // startTime/endTime are TimeSpan in C# → send as "08:00:00" format
  static Future<void> overrideDayAvailability({
    required String date,
    required String startTime, // format: "HH:mm" → we append ":00"
    required String endTime,
  }) async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseDayOverride);

    // Ensure seconds are included for TimeSpan parsing: "08:00" → "08:00:00"
    final start = startTime.length == 5 ? '$startTime:00' : startTime;
    final end = endTime.length == 5 ? '$endTime:00' : endTime;

    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
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

  // FIX: POST /api/Nurse/availability/block-day
  // Body: { date: ISO DateTime string }
  // Backend DTO: BlockDayDto { DateTime Date }
  static Future<void> blockDayAvailability({required String date}) async {
    final token = await _requireToken();
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.nurseDayBlock);

    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "date": _toIsoDateTime(date), // "2026-03-18T00:00:00.000Z"
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to block day"),
      );
    }
  }

  // FIX: DELETE /api/Nurse/availability/override?date=ISO_DATE
  // This is the unblock — it deletes the override record (which had IsBlocked=true)
  static Future<void> unblockDayAvailability({required String date}) async {
    final token = await _requireToken();
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.nurseDayUnblock}?date=${_toIsoDateTime(date)}",
    );

    final response = await http
        .delete(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
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

  static String _ensureTimeSeconds(String time) {
    return time.length == 5 ? "$time:00" : time;
  }

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

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data is Map<String, dynamic> ? data : {};
      } else {
        throw Exception(
          _extractErrorMessage(response.body, fallback: "Failed to browse nurses"),
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
        .get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response.body, fallback: "Failed to load nurse details"),
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

  print('🌐 GET PATIENT NURSE SERVICES URL: $url');
  print('🔐 AUTH HEADER EXISTS: ${token.isNotEmpty}');

  final response = await http
      .get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      )
      .timeout(const Duration(seconds: 15));

  print('📡 GET PATIENT NURSE SERVICES STATUS: ${response.statusCode}');
  print('📦 GET PATIENT NURSE SERVICES BODY: ${response.body}');

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
      .get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      )
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

  print("📤 BOOKING BODY: $body");

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode(body),
  );

  print("📡 BOOKING STATUS: ${response.statusCode}");
  print("📦 BOOKING RESPONSE: ${response.body}");

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
      .get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      )
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
static Future<List<dynamic>> getNurseRequests({
  String? status,
}) async {
  final token = await _requireToken();

  final uri = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.nurseRequests}",
  ).replace(
    queryParameters: status == null ? null : {"status": status},
  );

  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

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

  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

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

static Future<void> acceptNurseRequest({
  required int bookingId,
}) async {
  final token = await _requireToken();

  final uri = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.nurseRequests}/$bookingId/accept",
  );

  final response = await http.put(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to accept request",
      ),
    );
  }
}

static Future<void> declineNurseRequest({
  required int bookingId,
}) async {
  final token = await _requireToken();

  final uri = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.nurseRequests}/$bookingId/decline",
  );

  final response = await http.put(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

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
// Patient - Appointments
// =========================

static Future<List<Appointment>> getPatientAppointments({
  required String tab,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.patientAppointments}?tab=$tab",
  );

  print("GET PATIENT APPOINTMENTS URL: $url");

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  print("GET PATIENT APPOINTMENTS STATUS: ${response.statusCode}");
  print("GET PATIENT APPOINTMENTS BODY: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to load appointments",
      ),
    );
  }

  final data = jsonDecode(response.body);

  if (data is! List) return [];

  return data
      .map<Appointment>(
        (item) => Appointment.fromPatientJson(item as Map<String, dynamic>),
      )
      .toList();
}
static Future<void> cancelPatientAppointment({
  required String bookingId,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.patientAppointments}/$bookingId/cancel",
  );

  final response = await http
      .put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      )
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

  print("GET PATIENT APPOINTMENT DETAILS URL: $url");
  print("GET PATIENT APPOINTMENT DETAILS BOOKING ID: $bookingId");

  final response = await http
      .get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      )
      .timeout(const Duration(seconds: 15));

  print("GET PATIENT APPOINTMENT DETAILS STATUS: ${response.statusCode}");
  print("GET PATIENT APPOINTMENT DETAILS BODY: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to load appointment details",
      ),
    );
  }

  final data = jsonDecode(response.body);

  if (data is! Map<String, dynamic>) {
    throw Exception("Invalid appointment details response");
  }

  return Appointment.fromPatientDetailsJson(data);
}
static Future<List<Appointment>> getNurseAppointments({
  required String tab,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.nurseAppointments}?tab=$tab",
  );

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

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

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to load nurse appointment details",
      ),
    );
  }

  final data = jsonDecode(response.body);
  if (data is! Map<String, dynamic>) {
    throw Exception("Invalid nurse appointment details response");
  }

  return Appointment.fromNurseDetailsJson(data);
}

static Future<void> completeNurseAppointment({
  required String bookingId,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.nurseAppointments}/$bookingId/complete",
  );

  final response = await http.put(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to complete appointment",
      ),
    );
  }
}

static Future<void> cancelNurseAppointment({
  required String bookingId,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.nurseAppointments}/$bookingId/cancel",
  );

  final response = await http.put(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to cancel appointment",
      ),
    );
  }
}
static Future<void> confirmPayment({
  required String bookingId,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.confirmPayment}/$bookingId",
  );

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to confirm payment",
      ),
    );
  }
}
static Future<String> createPaymentIntent({
  required String bookingId,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.createPaymentIntent}/$bookingId",
  );

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["clientSecret"];
  } else {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to create payment intent",
      ),
    );
  }
}
static Future<Map<String, dynamic>> getPaymentSummary({
  required String bookingId,
}) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.paymentSummary}/$bookingId",
  );

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
      _extractErrorMessage(
        response.body,
        fallback: "Failed to load payment summary",
      ),
    );
  }
}
static Future<List<NotificationModel>> getNotifications() async {
  final token = await _requireToken();

  final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.notifications}");

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load notifications");
  }
}
static Future<void> markNotificationAsRead(int id) async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.notifications}/$id/read",
  );

  final response = await http.put(
    url,
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to mark notification as read");
  }
}
static Future<void> markAllNotificationsAsRead() async {
  final token = await _requireToken();

  final url = Uri.parse(
    "${ApiConstants.baseUrl}${ApiConstants.notifications}/read-all",
  );

  final response = await http.put(
    url,
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to mark all notifications as read");
  }
}
}
