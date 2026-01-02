import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:complaints/core/services/notification/notification_service.dart';

import '../../../core/constants/appcolor.dart';
import '../../../data/models/notification/notification_model.dart';
import '../../complaint/controller/user_complaint_controller/user_complaint_controller.dart';


class NotificationController extends GetxController {
  final NotificationService _notificationService = Get.find();

  RxList<NotificationModel> get notifications =>
      _notificationService.notifications;

  RxInt get unreadCount => _notificationService.unreadCount;
  RxBool get isLoading => _notificationService.isLoading;

  var showUnreadOnly = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchNotifications();
  }

  // /// جلب الإشعارات
  // Future<void> fetchNotifications() async {
  //   await _notificationService.fetchNotifications(
  //     status: showUnreadOnly.value ? 'unread' : null,
  //   );
  // }

  Future<void> fetchNotifications() async {
    await _notificationService.fetchNotifications(
      status: showUnreadOnly.value ? 'unread' : null,
    );

    linkComplaintsToNotifications();
  }

  void toggleFilter() {
    showUnreadOnly.value = !showUnreadOnly.value;
    fetchNotifications();
  }

  Future<void> markAllAsRead() async {
    await _notificationService.markAllAsRead();
  }

   onNotificationTap(NotificationModel notification) async {
    if (!notification.isRead) {
      notification.isRead = true;
      notifications.refresh();
    }

    await _notificationService.markAsRead(notification.id);

    switch (notification.type) {
      case 'complaint_update':
        if (notification.data?['complaint_id'] != null) {
          Get.toNamed(
            '/user-complaint',
            arguments: {
              'complaintId': notification.data?['complaint_id'],
            },
          );
        }
        break;

      case 'new_message':
        Get.toNamed('/chat');
        break;

      default:
        Get.defaultDialog(
          title: notification.getComplaintTitle(),
          middleText: notification.getDisplayBody(),
          titleStyle:TextStyle(color: AppColor.blue)
        );
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  Future<void> loadNextPage() async {
    await _notificationService.loadNextPage();
  }

  Future<void> loadPreviousPage() async {
    await _notificationService.loadPreviousPage();
  }


  void linkComplaintsToNotifications() {
    if (!Get.isRegistered<UserComplaintController>()) return;

    final userComplaintController = Get.find<UserComplaintController>();

    for (var notification in notifications) {
      if (notification.complaintId != null) {

      }
    }
  }


}
