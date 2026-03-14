import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'token_storage.dart';

class ApiService {
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
      throw Exception(response.body);
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
      throw Exception(response.body);
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
        throw Exception(response.body);
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
    } on SocketException {
      throw Exception(
        "Unable to connect to the server. Check your backend, IP address, and network.",
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
      throw Exception(response.body);
    }
  }

  static Future<void> submitNurseRegistrationMultipart({
    required String phoneNumber,
    required String address,
    required String location,
    required String nationalIdNumber,
    required String specialization,
    required String experienceYears,
    required File nationalIdFile,
    required File licenseFile,
    required File profilePhotoFile,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception("User not logged in");
    }

    final url = Uri.parse(
      ApiConstants.baseUrl + ApiConstants.nurseUpdateProfile,
    );

    final request = http.MultipartRequest("PUT", url);

    request.headers["Authorization"] = "Bearer $token";

    request.fields["PhoneNumber"] = phoneNumber;
    request.fields["Address"] = address;
    request.fields["Location"] = location;
    request.fields["NationalId"] = nationalIdNumber;
    request.fields["Specialization"] = specialization;
    request.fields["ExperienceYears"] = experienceYears;

    request.files.add(
      await http.MultipartFile.fromPath("NationalIdFile", nationalIdFile.path),
    );

    request.files.add(
      await http.MultipartFile.fromPath("License", licenseFile.path),
    );

    request.files.add(
      await http.MultipartFile.fromPath("ProfilePhoto", profilePhotoFile.path),
    );

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );

    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      throw Exception("HTTP ${streamedResponse.statusCode}: $responseBody");
    }
  }

  static Future<Map<String, dynamic>> getMe() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

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
}
