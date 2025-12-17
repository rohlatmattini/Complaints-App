import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../controller/localization/locale_controller.dart';
import '../../../data/model/complaint/complaint_meta_model.dart';
import '../../constant/app_links.dart';
import 'complaint_cache_service.dart';

class ComplaintService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final MyLocaleController langController = Get.find();
  final ComplaintCacheService cache = ComplaintCacheService();

  Future<ComplaintMeta?> getComplaintMeta() async {
    try {
      print('🔍 Getting complaint meta with cache strategy...');

      final cachedMeta = await cache.getMeta();
      if (cachedMeta != null) {
        print(' Returning cached data');
        return cachedMeta;
      }

      print(' Cache not available, fetching from API...');
      final freshMeta = await _fetchComplaintMetaFromApi();

      if (freshMeta != null) {
        await cache.saveMeta(freshMeta);
        print(' Cache updated with fresh data');
        return freshMeta;
      }

      return null;
    } catch (e) {
      print(' Error in getComplaintMeta: $e');
      return null;
    }
  }

  Future<ComplaintMeta?> _fetchComplaintMetaFromApi() async {
    try {
      final token = await storage.read(key: 'token');

      print(' Fetching from: ${AppLinks.baseUrl}/complaints/meta');
      print(' Token exists: ${token != null}');

      final response = await http.get(
        Uri.parse('${AppLinks.baseUrl}/complaints/meta'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': langController.currentLangFromPref,
          'Authorization': 'Bearer $token',
        },
      );

      print(' API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(' API data received successfully');
        return ComplaintMeta.fromJson(data);
      } else {
        print(' Failed to load complaint meta: ${response.statusCode}');
        print(' Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print(' Error fetching complaint meta from API: $e');
      return null;
    }
  }

  Future<ComplaintMeta?> refreshComplaintMeta() async {
    try {
      print(' Forcing refresh of complaint meta...');
      await cache.clear();
      return await _fetchComplaintMetaFromApi();
    } catch (e) {
      print(' Error refreshing complaint meta: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitComplaint(Map<String, dynamic> complaintData) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await http.post(
        Uri.parse('${AppLinks.baseUrl}/complaints'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(complaintData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to submit complaint: ${response.statusCode}');
        return null;
      }

    } catch (e) {
      print('Error submitting complaint: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitComplaintMultipart(
      Map<String, String> data,
      List<File> attachments,
      ) async {
    try {
      final token = await storage.read(key: 'token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppLinks.baseUrl}/complaints'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      data.forEach((key, value) {
        request.fields[key] = value;
      });

      for (int i = 0; i < attachments.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachments[]',
            attachments[i].path,
          ),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print("API response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Error submitting complaint: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Multipart error: $e");
      return null;
    }
  }
}



