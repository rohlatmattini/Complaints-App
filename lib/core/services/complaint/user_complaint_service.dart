
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/models/complaint/user_complaint.dart';
import '../../constants/app_links.dart';
import '../../localization/locale_controller.dart';

class UserComplaintService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final MyLocaleController langController = Get.find();

  Future<UserComplaintResponse?> getUserComplaints({int page = 1}) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await http.get(
        Uri.parse('${AppLinks.baseUrl}/complaints?page=$page'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': langController.currentLangFromPref,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserComplaintResponse.fromJson(data);
      } else {
        print('Failed to load user complaints: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user complaints: $e');
      return null;
    }
  }

  Future<UserComplaint?> getComplaintDetails(int complaintId) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await http.get(
        Uri.parse('${AppLinks.baseUrl}/complaints/$complaintId'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': langController.currentLangFromPref,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserComplaint.fromJson(data['data']);
      } else {
        print('Failed to load complaint details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching complaint details: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> updateComplaintSimple(
  int complaintId,
  Map<String, dynamic> data,
  ) async {
  try {
    final token = await storage.read(key: 'token');
    final response = await http.put(
  Uri.parse('${AppLinks.baseUrl}/complaints/$complaintId'),
  headers: {
    'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  },
  body: json.encode(data),
  );

  if (response.statusCode == 200) {
  return json.decode(response.body);
  } else {
  print('Update failed: ${response.statusCode} - ${response.body}');
  return null;
  }
  } catch (e) {
  print('Error updating complaint: $e');
  return null;
  }
  }

  Future<Map<String, dynamic>?> updateComplaint(
      int complaintId,
      Map<String, dynamic> data,
      ) async {
    try {
      final token = await storage.read(key: 'token');

      print('Updating complaint $complaintId with data: $data');

      final response = await http.put(
        Uri.parse('${AppLinks.baseUrl}/complaints/$complaintId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': langController.currentLangFromPref,
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        print('Failed to update complaint: ${response.statusCode}');
        print('Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error updating complaint: $e');
      return null;
    }
  }

}

