import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/complaint/complaint_model.dart';
import '../../../../data/models/complaint/user_complaint.dart';

class ComplaintFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var isEditing = false.obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  var editingComplaintId = Rxn<int>();

  var complaint = ComplaintModel(
    title: '',
    description: '',
    complaintType: '',
    responsibleEntity: '',
    location: '',
    referenceNumber: _generateReferenceNumber(),
    createdAt: DateTime.now(),
  ).obs;

  var priorities = ['low', 'medium', 'high'].obs;
  var selectedPriority = 'medium'.obs;
  var selectedRegion = ''.obs;

  // Form validation
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter complaint title'.tr;
    }
    if (value.trim().length < 5) {
      return 'Title must be at least 5 characters'.tr;
    }
    return null;
  }

  String? validateComplaintType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select complaint type'.tr;
    }
    return null;
  }

  String? validateResponsibleEntity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select responsible entity'.tr;
    }
    return null;
  }

  String? validateRegion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select region'.tr;
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter description'.tr;
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters'.tr;
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter location'.tr;
    }
    return null;
  }

  // Form updates
  void updateTitle(String value) {
    complaint.value = complaint.value.copyWith(title: value);
  }

  void updateComplaintType(String? value) {
    if (value != null) {
      complaint.value = complaint.value.copyWith(complaintType: value);
    }
  }

  void updateResponsibleEntity(String? value) {
    if (value != null) {
      complaint.value = complaint.value.copyWith(responsibleEntity: value);
    }
  }

  void updateRegion(String? value) {
    if (value != null) selectedRegion.value = value;
  }

  void updateDescription(String value) {
    complaint.value = complaint.value.copyWith(description: value);
  }

  void updateLocation(String value) {
    complaint.value = complaint.value.copyWith(location: value);
  }

  void updatePriority(String? value) {
    if (value != null) selectedPriority.value = value;
  }


  // دالة للإعداد قبل الإرسال
  void prepareFormData() {
    // تحديث نموذج الشكوى من الـ controllers
    updateTitle(titleController.text.trim());
    updateDescription(descriptionController.text.trim());
    updateLocation(locationController.text.trim());
  }

  // Form reset
  void clearForm() {
    isEditing.value = false;
    editingComplaintId.value = null;
    titleController.clear();
    descriptionController.clear();
    locationController.clear();

    complaint.value = ComplaintModel(
      title: '',
      description: '',
      complaintType: '',
      responsibleEntity: '',
      location: '',
      referenceNumber: _generateReferenceNumber(),
      createdAt: DateTime.now(),
    );

    selectedPriority.value = 'medium';
    selectedRegion.value = '';

  }

  static String _generateReferenceNumber() {
    final now = DateTime.now();
    return 'COMP${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }

  void loadComplaintToEdit(UserComplaint oldComplaint) {
    isEditing.value = true;
    editingComplaintId.value = oldComplaint.id;

    titleController.text = oldComplaint.title;
    descriptionController.text = oldComplaint.description;

    if (oldComplaint.region != null) {
      selectedRegion.value = oldComplaint.region!.name;
      locationController.text = oldComplaint.region!.name;
    }

    selectedPriority.value = oldComplaint.priority;

    complaint.update((val) {
      val?.title = oldComplaint.title;
      val?.description = oldComplaint.description;
      val?.complaintType = oldComplaint.category.label;
      val?.responsibleEntity = oldComplaint.department.name;
      val?.location = oldComplaint.region?.name ?? '';
    });
  }  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }
}