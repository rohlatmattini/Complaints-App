import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/events/complaint_event_bus.dart';
import '../../../core/services/complaint/complaint_service.dart';
import '../../../view/screen/complaint/user_complaint_screen.dart';
import 'complaint_attachment_controller.dart';
import 'complaint_form_controller.dart';
import 'complaint_meta_controller.dart';

class ComplaintSubmissionController extends GetxController {
  final ComplaintService _complaintService = ComplaintService();
  final ComplaintFormController formController = Get.find();
  final ComplaintAttachmentController attachmentController = Get.find();
  final ComplaintMetaController metaController = Get.find();

  var isLoading = false.obs;

  Future<void> submitComplaint() async {
    // Validate form
    if (!formController.formKey.currentState!.validate()) return;
    if (formController.selectedRegion.value.isEmpty) {
      Get.snackbar('Error'.tr, 'Please select region'.tr);
      return;
    }

    // Prepare form data
    _prepareFormData();

    // Validate required fields
    if (formController.complaint.value.complaintType.isEmpty ||
        formController.complaint.value.responsibleEntity.isEmpty) {
      Get.snackbar('Error'.tr, 'Please fill all required fields'.tr);
      return;
    }

    try {
      isLoading.value = true;

      // Prepare complaint data for API
      final complaintData = _prepareApiData();

      print("Sending data: $complaintData");

      // Submit to API
      final response = await _complaintService.submitComplaintMultipart(
        complaintData,
        attachmentController.attachedFiles,
      );

      if (response != null && response['data'] != null) {
        Get.snackbar('Success'.tr, 'Complaint submitted successfully'.tr);
        ComplaintEvents.notify(ComplaintEventType.newComplaint);
        _resetAll();
        Get.to(() => UserComplaintsScreen ());
      } else {
        Get.snackbar('Error'.tr, 'Failed to submit complaint'.tr);
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to submit complaint: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _prepareFormData() {
    formController.updateTitle(formController.titleController.text.trim());
    formController.updateDescription(
        formController.descriptionController.text.trim());
    formController.updateLocation(
        formController.locationController.text.trim());
  }

  Map<String, String> _prepareApiData() {
    final categoryId = _getCategoryIdFromLabel(formController.complaint.value.complaintType);
    final departmentId = _getDepartmentIdFromLabel(formController.complaint.value.responsibleEntity);
    final regionId = _getRegionIdFromLabel(formController.selectedRegion.value);

    return {
      'title': formController.complaint.value.title,
      'description': formController.complaint.value.description,
      'category_id': categoryId?.toString() ?? '',
      'department_id': departmentId?.toString() ?? '',
      'region_id': regionId?.toString() ?? '',
      'priority': formController.selectedPriority.value,
      'location': formController.complaint.value.location,
    };
  }

  int? _getCategoryIdFromLabel(String label) {
    try {

      // البحث في القائمة
      final category = metaController.categories.firstWhere((cat) => cat.label == label);
      return category.id;
    } catch (e) {
      print('Category not found: $label - Will be sent as custom value');
      return null;
    }
  }

  int? _getDepartmentIdFromLabel(String name) {
    try {

      // البحث في القائمة
      final department = metaController.departments.firstWhere((dept) => dept.name == name);
      return department.id;
    } catch (e) {
      print('Department not found: $name - Will be sent as custom value');
      return null;
    }
  }

  int? _getRegionIdFromLabel(String name) {
    try {
      final region = metaController.regions.firstWhere((region) => region.name == name);
      return region.id;
    } catch (e) {
      print('Region not found: $name');
      return null;
    }
  }

  void _resetAll() {
    formController.clearForm();
    attachmentController.clearFiles();
  }
}



