import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/models/complaint/complaint_meta_model.dart';
import '../../constants/app_links.dart';
import '../../localization/locale_controller.dart';
import 'complaint_cache_service.dart';
import 'package:path/path.dart' as path;

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
  Future<Map<String, dynamic>?> replyToInfoRequest(
      int complaintId,
      String message,
      List<File> attachments,
      ) async {
    try {
      final token = await storage.read(key: 'token');

      print('Replying to info request for complaint ID: $complaintId');
      print('Message: $message');
      print('Number of attachments: ${attachments.length}');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppLinks.baseUrl}/complaints/$complaintId/reply-info'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['Accept-Language'] = langController.currentLangFromPref;

      // إضافة الرسالة
      if (message.isNotEmpty) {
        request.fields['message'] = message;
      }

      // إضافة المرفقات
      for (int i = 0; i < attachments.length; i++) {
        final file = attachments[i];
        final fileName = path.basename(file.path);
        final fileExtension = fileName.split('.').last.toLowerCase();

        // تحديد نوع الملف
        String mimeType = 'application/octet-stream';
        if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (fileExtension == 'png') {
          mimeType = 'image/png';
        } else if (fileExtension == 'pdf') {
          mimeType = 'application/pdf';
        } else if (fileExtension == 'doc') {
          mimeType = 'application/msword';
        } else if (fileExtension == 'docx') {
          mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        } else if (fileExtension == 'txt') {
          mimeType = 'text/plain';
        }

        final fileStream = http.ByteStream(file.openRead());
        final length = await file.length();

        final multipartFile = http.MultipartFile(
          'attachments[]',
          fileStream,
          length,
          filename: fileName,
          contentType: http.MediaType.parse(mimeType),
        );

        request.files.add(multipartFile);
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Successfully submitted additional information');
        return responseData;
      } else {
        print('Error submitting information: ${response.statusCode}');
        print('Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in replyToInfoRequest: $e');
      return null;
    }
  }
}



