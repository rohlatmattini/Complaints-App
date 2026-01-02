import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart'as http;

import '../../../data/models/Auth/login.dart';
import '../../../data/models/Auth/signup.dart';
import '../../constants/app_links.dart';
import '../../localization/locale_controller.dart';


class ApiService {
  final MyLocaleController langController = Get.find();

  Future<Map<String, dynamic>?> register(SignUpModel model) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/register');

    final headers = {
      'Accept': 'application/json',
      'Accept-Language': langController.currentLangFromPref,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(model.toJson()),
      );

      final data = jsonDecode(response.body);

      // استخراج التوكن بشكل آمن
      final token = data['data']?['token'];

      if (token != null) {
        print('Token: $token');
      } else {
        print('Token is null!');
      }

      return data;

    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> verifyEmail(String code, String token) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/verify-email');

    final headers = {
      'Accept': 'application/json',
      'Accept-Language': langController.currentLangFromPref,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({"code": code}),
      );

      print('Verify Status Code: ${response.statusCode}');
      print('Verify Body: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('Verify Exception: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(LoginModel model) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/login');


    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(model.toJson()),
      );

      print('Login Status Code: ${response.statusCode}');
      print('Login Response: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('Login Exception: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> forgotPassword(String email) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/password/forgot');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({"email": email}),
      );

      print("Forgot Status: ${response.statusCode}");
      print("Forgot Body: ${response.body}");

      return jsonDecode(response.body);

    } catch (e) {
      print("Forgot Exception: $e");
      return null;
    }
  }


  Future<Map<String, dynamic>?> resetPassword({
    required String email,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/password/reset');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          "email": email,
          "code": code,
          "password": password,
          "password_confirmation": confirmPassword
        }),
      );

      print("Reset Status: ${response.statusCode}");
      print("Reset Body: ${response.body}");

      return jsonDecode(response.body);

    } catch (e) {
      print("Reset Exception: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> resendVerification(String token) async {
    try {
      final uri = Uri.parse('${AppLinks.baseUrl}/email/resend-verification');

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);

    } catch (e) {
      print("RESEND ERROR => $e");
      return null;
    }
  }


  // في ملف ApiService.dart
  Future<Map<String, dynamic>?> logout(String token) async {
    final uri = Uri.parse('${AppLinks.baseUrl}/logout');

    final headers = {
      'Accept': 'application/json',
      'Accept-Language': langController.currentLangFromPref,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final request = http.Request('POST', uri);
      request.headers.addAll(headers);

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print('Logout Status Code: ${response.statusCode}');
      print('Logout Response: $responseString');

      if (response.statusCode == 200) {
        return jsonDecode(responseString);
      } else {
        return {'success': false, 'message': 'Logout failed'};
      }
    } catch (e) {
      print('Logout Exception: $e');
      return null;
    }
  }




}