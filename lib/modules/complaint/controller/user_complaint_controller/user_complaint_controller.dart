// lib/controller/complaint/user_complaint_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/appcolor.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/services/complaint/user_complaint_service.dart';
import '../../../../data/models/complaint/user_complaint.dart';
import '../../complaint_event_bus.dart';


class UserComplaintController extends GetxController {
  final UserComplaintService _complaintService = UserComplaintService();
  final MyLocaleController _localeController = Get.find();

  // State variables
  var complaints = <UserComplaint>[].obs;
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;
  var selectedComplaint = Rxn<UserComplaint>();

  // Search and filter
  var searchQuery = ''.obs;
  var statusFilter = Rxn<String>();
  var priorityFilter = Rxn<String>();
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    loadComplaints();

    _subscribeToComplaintEvents();
    _subscribeToLanguageChanges();


  }

  void _subscribeToLanguageChanges() {
    ever(_localeController.currentLang, (String newLang) {
      refreshComplaints();
    });
  }
  void onClose() {

    super.onClose();
  }

  void _subscribeToComplaintEvents() {
    ever(ComplaintEvents.complaintStream, (event) {
      if (event != ComplaintEventType.none) {
        _handleComplaintEvent(event);
      }
    });
  }

  void _handleComplaintEvent(ComplaintEventType event) {
    switch (event) {
      case ComplaintEventType.newComplaint:
      case ComplaintEventType.statusUpdated:
      case ComplaintEventType.refreshAll:
        refreshComplaints();
        break;
      case ComplaintEventType.none:
        break;
    }
  }



  Future<void> loadComplaints({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
      isRefreshing.value = true;
    } else {
      if (!hasMore.value || isLoading.value) return;
      isLoading.value = true;
    }

    try {
      final response = await _complaintService.getUserComplaints(
        page: currentPage.value,
      );

      if (response != null) {
        if (refresh) {
          complaints.clear();
        }

        complaints.addAll(response.complaints);

        hasMore.value = currentPage.value < response.lastPage;
        currentPage.value++;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      print('Error loading complaints: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_load_complaints'.tr,
        backgroundColor: AppColor.red,
        colorText: AppColor.white,
      );
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refreshComplaints() async {
    await loadComplaints(refresh: true);
  }


  Future<UserComplaint?> loadComplaintDetails(int complaintId) async {
    try {
      isLoading.value = true;

      final complaint =
      await _complaintService.getComplaintDetails(complaintId);

      selectedComplaint.value = complaint;
      return complaint;
    } catch (e) {
      print('Error loading complaint details: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_load_complaint_details'.tr,
        backgroundColor: AppColor.red,
        colorText: AppColor.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  List<UserComplaint> get filteredComplaints {
    var filtered = complaints.toList();

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((complaint) =>
      complaint.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          complaint.description.toLowerCase().contains(
              searchQuery.toLowerCase()) ||
          complaint.category.label.toLowerCase().contains(
              searchQuery.toLowerCase()))
          .toList();
    }

    if (statusFilter.value != null) {
      filtered = filtered.where((complaint) =>
      ComplaintTextHelper.normalizeStatus(complaint.status) == statusFilter.value
      ).toList();
    }


    if (priorityFilter.value != null) {
      filtered = filtered.where((complaint) =>
      complaint.priority == priorityFilter.value).toList();
    }

    return filtered;
  }
  UserComplaint? getComplaintById(int id) {
    return complaints.firstWhereOrNull((c) => c.id == id);
  }


  Future<UserComplaint?> getOrLoadComplaint(int id) async {
    final existing =
    complaints.firstWhereOrNull((c) => c.id == id);
    if (existing != null) return existing;

    final complaint = await loadComplaintDetails(id);
    return complaint;
  }


  void clearFilters() {
    searchQuery.value = '';
    statusFilter.value = null;
    priorityFilter.value = null;
  }
}






class ComplaintTextHelper {
  static String normalizeStatus(String status) {
    String cleanStatus = status.contains('.') ? status.split('.').last : status;
    final s = cleanStatus.toLowerCase().trim();

    if (s.contains('مراجعة') || s.contains('pending') || s.contains('review')) {
      return 'pending';
    }
    if (s.contains('مفتوحة') || s.contains('open')) {
      return 'open';
    }
    if (s.contains('مرفوض') || s.contains('reject')) {
      return 'rejected';
    }
    if (s.contains('تم الحل') || s.contains('resolved')) {
      return 'resolved';
    }
    if (s.contains('مغلقة') || s.contains('closed')) {
      return 'closed';
    }
    if (s.contains('تحت المعالجة') || s.contains('in progress')) {
      return 'in progress';
    }
    if (s.contains('needs_more_info') || s.contains('معلومات اضافية')) {
      return 'needs_more_info';
    }


    return s;
  }


  static String getPriorityText(String priority) {
    final priorityLower = priority.toLowerCase().trim();

    if (priorityLower.contains('عالية') || priorityLower.contains('high')) {
      return 'high';
    } else
    if (priorityLower.contains('متوسطة') || priorityLower.contains('medium')) {
      return 'medium';
    } else
    if (priorityLower.contains('منخفضة') || priorityLower.contains('low')) {
      return 'low';
    }

    return priority;
  }


}