// // lib/view/screen/notification/notifications_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:complaints/controller/notification/notification_controller.dart';
// import 'package:complaints/controller/complaint/user_complaint_controller/user_complaint_controller.dart';
// import 'package:complaints/core/shared/load_indicator.dart';
// import 'package:complaints/data/model/notification/notification_model.dart';
//
// class NotificationsScreen extends StatelessWidget {
//   NotificationsScreen({super.key});
//
//   final NotificationController controller = Get.find();
//   final UserComplaintController userComplaintController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(
//               () => Text(
//             '${"Notifications".tr}'
//                 '${controller.unreadCount.value > 0 ? ' (${controller.unreadCount.value})' : ''}',
//             style: const TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         actions: [
//           /// فلتر غير المقروء
//           IconButton(
//             onPressed: controller.toggleFilter,
//             icon: Obx(
//                   () => Icon(
//                 controller.showUnreadOnly.value
//                     ? Icons.filter_alt
//                     : Icons.filter_alt_outlined,
//                 color: controller.showUnreadOnly.value
//                     ? Colors.blue
//                     : null,
//               ),
//             ),
//           ),
//
//           /// تعليم الكل كمقروء
//           Obx(
//                 () => controller.unreadCount.value > 0
//                 ? IconButton(
//               onPressed: controller.markAllAsRead,
//               icon: const Icon(Icons.done_all),
//             )
//                 : const SizedBox.shrink(),
//           ),
//
//           /// تحديث
//           IconButton(
//             onPressed: controller.refreshNotifications,
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value &&
//             controller.notifications.isEmpty) {
//           return const Center(
//             child: LoadMoreIndicator(isLoading: true),
//           );
//         }
//
//         if (controller.notifications.isEmpty) {
//           return const Center(
//             child: Text(
//               'لا توجد إشعارات',
//               style: TextStyle(color: Colors.grey),
//             ),
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: controller.refreshNotifications,
//           child: ListView.separated(
//             itemCount: controller.notifications.length,
//             separatorBuilder: (_, __) =>
//                 Divider(height: 1, color: Colors.grey[300]),
//             itemBuilder: (context, index) {
//               final notification = controller.notifications[index];
//
//               /// ⭐ ربط الإشعار بالشكوى
//               if (notification.type == 'complaint_update' &&
//                   notification.data?['complaint_id'] != null) {
//                 final complaintId =
//                 notification.data!['complaint_id'];
//
//                 return FutureBuilder(
//                   future: userComplaintController
//                       .getOrLoadComplaint(complaintId),
//                   builder: (context, snapshot) {
//                     final complaint = snapshot.data;
//
//                     final complaintTitle = complaint != null
//                         ? complaint.title
//                         : notification.body;
//
//                     return _NotificationTile(
//                       notification: notification,
//                       complaintTitle: complaintTitle,
//                       controller: controller,
//                     );
//                   },
//                 );
//               }
//
//               /// إشعارات أخرى
//               return _NotificationTile(
//                 notification: notification,
//                 complaintTitle: notification.body,
//                 controller: controller,
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
//
// /// ====== Widget منفصل للنظافة ======
// class _NotificationTile extends StatelessWidget {
//   final NotificationModel notification;
//   final String complaintTitle;
//   final NotificationController controller;
//
//   const _NotificationTile({
//     required this.notification,
//     required this.complaintTitle,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () => controller.onNotificationTap(notification),
//       leading: CircleAvatar(
//         backgroundColor:
//         notification.isRead ? Colors.grey[200] : Colors.blue[50],
//         child: Icon(
//           _getNotificationIcon(notification.type),
//           color: notification.isRead ? Colors.grey : Colors.blue,
//         ),
//       ),
//       title: Text(
//         notification.title,
//         style: TextStyle(
//           fontWeight:
//           notification.isRead ? FontWeight.normal : FontWeight.bold,
//         ),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 4),
//           Text(
//             complaintTitle,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             notification.formattedTime,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//       trailing: (!notification.isRead)
//           ? const CircleAvatar(
//         radius: 4,
//         backgroundColor: Colors.red,
//       )
//           : null,
//     );
//   }
//
//   IconData _getNotificationIcon(String type) {
//     switch (type) {
//       case 'complaint_update':
//         return Icons.assignment;
//       case 'new_message':
//         return Icons.message;
//       case 'system':
//         return Icons.info;
//       default:
//         return Icons.notifications;
//     }
//   }
// }



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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue,
        title: Obx(() => Text(
          '${"Notifications".tr}${controller.unreadCount.value > 0 ? ' (${controller.unreadCount.value})' : ''}',
          style: TextStyle(fontSize: 15,
              color: AppColor.white,
              fontWeight: FontWeight.bold),
        )),
        actions: [
          IconButton(
            onPressed: controller.toggleFilter,
            icon: Obx(
                  () => Icon(
                controller.showUnreadOnly.value
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
                color: controller.showUnreadOnly.value
                    ? Colors.blue
                    : null,
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
      ),      body: Obx(() {
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
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.showUnreadOnly.value
                      ? 'There are no unread notifications'.tr
                      : 'There are no notifications'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
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
              color: Colors.grey[300],
            ),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              final complaintInfo = notification.getComplaintInfo();

              return _buildNotificationItem(context, notification, complaintInfo);
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
      ) {
    return ListTile(
      onTap: () => controller.onNotificationTap(notification),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.grey[200] : Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getNotificationIcon(notification.type),
          color: notification.isRead ? Colors.grey : Colors.blue,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان الإشعار الرئيسي
          Text(
            notification.displayTitle,
            style: TextStyle(
              fontWeight:
              notification.isRead ? FontWeight.normal : FontWeight.bold,
              color: notification.isRead ? Colors.grey[700] : Colors.black,
            ),
          ),

          // عرض معلومات الشكوى إذا كانت موجودة
          if (notification.complaintId != null) ...[
            const SizedBox(height: 6),

            // اسم الشكوى
            if (complaintInfo['title']!.isNotEmpty)
              Text(
                complaintInfo['title']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[700],
                ),
              ),

            // الفئة والقسم
            if (complaintInfo['category']!.isNotEmpty ||
                complaintInfo['department']!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  '${complaintInfo['category']} - ${complaintInfo['department']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],

          // نص الإشعار الممنظف
          const SizedBox(height: 6),
          Text(
            notification.getDisplayBody(), // تغيير هنا
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: notification.isRead ? Colors.grey[600] : Colors.grey[800],
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          notification.formattedTime,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
      trailing: (!notification.isRead &&
          !controller.showUnreadOnly.value)
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
