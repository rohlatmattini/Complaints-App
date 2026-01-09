import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/complaint/complaint_service.dart';
import '../new_complaint_controller/complaint_attachment_controller.dart';

class ComplaintInfoReplyController extends GetxController {
  final ComplaintService _complaintService = ComplaintService();
  final attachmentController = Get.put(ComplaintAttachmentController());

  final TextEditingController messageController = TextEditingController();
  var isLoading = false.obs;
  var complaintId = 0.obs;
  var complaintNumber = ''.obs;
  var complaintTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadComplaintData();
  }

  void _loadComplaintData() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      complaintId.value = args['id'] ?? 0;
      complaintNumber.value = args['reference_number'] ?? '';
      complaintTitle.value = args['title'] ?? '';
    }
  }

  Future<void> submitAdditionalInfo() async {
    if (messageController.text.trim().isEmpty && attachmentController.attachedFiles.isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'Please provide a message or attach files'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _complaintService.replyToInfoRequest(
        complaintId.value,
        messageController.text.trim(),
        attachmentController.attachedFiles,
      );

      if (response != null && response['data'] != null) {
        Get.snackbar(
          'Success'.tr,
          'Additional information submitted successfully'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // إعادة تعيين النموذج
        messageController.clear();
        attachmentController.clearFiles();

        // العودة للخلف بعد تأخير بسيط
        await Future.delayed(Duration(milliseconds: 1500));
        Get.back(result: true);
      } else {
        throw Exception('Failed to submit information');
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to submit information: ${e.toString()}'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void cancel() {
    Get.back();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}