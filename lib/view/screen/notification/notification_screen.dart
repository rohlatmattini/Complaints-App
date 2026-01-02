

import 'package:complaints/core/constant/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:complaints/controller/notification/notification_controller.dart';
import 'package:complaints/core/shared/load_indicator.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:complaints/controller/notification/notification_controller.dart';
import 'package:complaints/core/shared/load_indicator.dart';

import '../../../data/model/notification/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController controller = Get.find();

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue,
        title: Obx(() => Text(
          '${"Notifications".tr}${controller.unreadCount.value > 0 ? ' (${controller.unreadCount.value})' : ''}',
          style: TextStyle(
            fontSize: 15,
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        )),
        actions: [
          IconButton(
            onPressed: controller.toggleFilter,
            icon: Obx(
                  () => Icon(
                controller.showUnreadOnly.value
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
                color: controller.showUnreadOnly.value ? Colors.blue : null,
              ),
            ),
          ),
          Obx(
                () => controller.unreadCount.value > 0
                ? IconButton(
              onPressed: controller.markAllAsRead,
              icon: const Icon(Icons.done_all),
            )
                : const SizedBox.shrink(),
          ),
          IconButton(
            onPressed: controller.refreshNotifications,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: LoadMoreIndicator(isLoading: true));
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: isDark ? Colors.white30 : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.showUnreadOnly.value
                      ? 'There are no unread notifications'.tr
                      : 'There are no notifications'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white60 : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColor.blue,
          onRefresh: () async {
            await controller.refreshNotifications();
          },
          child: ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? Colors.white12 : Colors.grey[300],
            ),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              final complaintInfo = notification.getComplaintInfo();

              return _buildNotificationItem(context, notification, complaintInfo, isDark);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context,
      NotificationModel notification,
      Map<String, String> complaintInfo,
      bool isDark,
      ) {
    return ListTile(
      onTap: () => controller.onNotificationTap(notification),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? Colors.white12 : Colors.grey[200])
              : (isDark ? Colors.white10 : Colors.blue[50]),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getNotificationIcon(notification.type),
          color: notification.isRead
              ? (isDark ? Colors.white60 : Colors.grey)
              : Colors.blue,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.displayTitle,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              color: notification.isRead
                  ? (isDark ? Colors.white70 : Colors.grey[700])
                  : (isDark ? Colors.white : Colors.black),
            ),
          ),
          if (notification.complaintId != null) ...[
            const SizedBox(height: 6),
            if (complaintInfo['title']!.isNotEmpty)
              Text(
                complaintInfo['title']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.blue[700],
                ),
              ),
            if (complaintInfo['category']!.isNotEmpty ||
                complaintInfo['department']!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  '${complaintInfo['category']} - ${complaintInfo['department']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ),
          ],
          const SizedBox(height: 6),
          Text(
            notification.getDisplayBody(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: notification.isRead
                  ? (isDark ? Colors.white60 : Colors.grey[600])
                  : (isDark ? Colors.white70 : Colors.grey[800]),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          notification.formattedTime,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.grey,
          ),
        ),
      ),
      trailing: (!notification.isRead && !controller.showUnreadOnly.value)
          ? Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      )
          : null,
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'complaint_update':
      case 'complaint_status_changed':
        return Icons.assignment;
      case 'new_message':
        return Icons.message;
      case 'system':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }
}
