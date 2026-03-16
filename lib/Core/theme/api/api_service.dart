import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'token_storage.dart';

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

  static String _extractErrorMessage(String body, {String fallback = "Request failed"}) {
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
      throw Exception(_extractErrorMessage(response.body, fallback: "Registration failed"));
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
      throw Exception(_extractErrorMessage(response.body, fallback: "Registration failed"));
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
        throw Exception(_extractErrorMessage(response.body, fallback: "Forgot password failed"));
      }

      final contentType = response.headers['content-type'] ?? '';

      if (contentType.contains('application/json')) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data["message"] != null) {
          return data["message"].toString();
        }

        if (data is Map<String, dynamic> && data["messsage"] != null) {
          return data["messsage"].toString();
        }

        if (data is Map<String, dynamic> && data["token"] != null) {
          return "Reset token generated successfully.";
        }
      }

      return response.body;
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
      throw Exception(_extractErrorMessage(response.body, fallback: "Reset password failed"));
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

    if (response.statusCode != 200) {
      throw Exception("Unauthorized");
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAccount() async {
    return getMe();
  }

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
          fallback: "Failed to load nurse profile",
        ),
      );
    }

    return jsonDecode(response.body);
  }

  // =========================
  // Nurse - Update Full Profile (multipart/form-data)
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
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "serviceCatalogId": serviceCatalogId,
            "price": price,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        _extractErrorMessage(
          response.body,
          fallback: "Failed to add service",
        ),
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
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
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
        _extractErrorMessage(
          response.body,
          fallback: "Failed to delete service",
        ),
      );
    }
  }
}
