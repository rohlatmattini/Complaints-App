import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../core/localization/locale_controller.dart';
import '../../core/services/notification/notification_service.dart';
import '../../data/models/notification/notification_model.dart';
import '../../main.dart';
import '../../modules/auth/controller/user_controller.dart';
import '../../modules/complaint/controller/user_complaint_controller/user_complaint_controller.dart';
import '../../modules/notification/controller/notification_controller.dart';
import '../../modules/notification/view/notification_screen.dart';
import '../theme/theme_controller.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 رسالة بالخلفية: ${message.notification?.title}");

  flutterLocalNotificationsPlugin.show(
    Random().nextInt(100000),
    message.notification?.title ?? "Notification",
    message.notification?.body ?? "",
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "fcm_channel",
        "FCM Notifications",
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // SharedPreferences
    sharedpref = await SharedPreferences.getInstance();

    // Firebase
    await Firebase.initializeApp();

    // Local notifications initialization
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("User clicked notification: ${response.payload}");

        try {
          if (response.payload != null) {
            final payload = json.decode(response.payload!);
            final notificationId = payload['notification_id'];
            final complaintId = payload['complaint_id'];
            final type = payload['type'];

            if (Get.isRegistered<NotificationService>()) {
              final notificationService = Get.find<NotificationService>();
              final notification = notificationService.notifications
                  .firstWhereOrNull((n) => n.id == notificationId);

              if (notification != null) {
                notification.isRead = true;
                notificationService.notifications.refresh();

                if (Get.isRegistered<NotificationController>()) {
                  final controller = Get.find<NotificationController>();
                  controller.onNotificationTap(notification);
                } else {
                  Get.to(() => NotificationsScreen());
                }
              } else {
                Get.to(() => NotificationsScreen());
              }
            }
          }
        } catch (e) {
          print('❌ خطأ في معالجة ضغط الإشعار: $e');
          Get.to(() => NotificationsScreen());
        }
      },
    );

    // Request notification permission
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN -----------------------------------: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("📩 رسالة أمامية: ${message.notification?.title}");

      final notification = await _createNotificationModelFromMessage(message);

      await _showLocalNotification(notification);

      _addNotificationToService(notification);


      _handleComplaintNotification(notification);


    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("🚀 المستخدم فتح التطبيق من إشعار");

      final notification = await _createNotificationModelFromMessage(message);

      _addNotificationToService(notification);

      _handleComplaintNotification(notification);


      _handleNotificationTap(notification);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Controllers
    Get.put(MyLocaleController());
    Get.put(ThemeController());
    Get.put(UserController());
    Get.put(NotificationService());
    Get.put(NotificationController());
  }


  static Future<NotificationModel> _createNotificationModelFromMessage(
      RemoteMessage message) async {
    int notificationId = message.data['id'] != null
        ? int.tryParse(message.data['id'].toString()) ?? Random().nextInt(100000)
        : Random().nextInt(100000);

    final title = message.notification?.title ?? 'إشعار جديد';
    final body = message.notification?.body ?? '';
    final type = message.data['type'] ?? 'general';
    final data = message.data;

    return NotificationModel(
      id: notificationId,
      title: title,
      body: body,
      type: type,
      data: data,
      createdAt: DateTime.now(),
      isRead: false,
    );
  }

  static Future<void> _showLocalNotification(NotificationModel notification) async {
    final notificationText = notification.getNotificationSummary();
    final complaintInfo = notification.getComplaintInfo();

    final payload = json.encode({
      'notification_id': notification.id,
      'type': notification.type,
      'complaint_id': notification.complaintId,
      'title': notification.title,
    });

    String fullText = '';
    if (complaintInfo['title']!.isNotEmpty) {
      fullText += '📋 ${complaintInfo['title']}\n\n';
    }
    fullText += notification.getDisplayBody();

    await flutterLocalNotificationsPlugin.show(
      notification.id,
      notification.displayTitle,
      fullText,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "fcm_channel",
          "FCM Notifications",
          channelDescription: "إشعارات التطبيق",
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            fullText,
            contentTitle: notification.displayTitle,
            summaryText: complaintInfo['title'] ?? '',
            htmlFormatBigText: false,
          ),
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          color: const Color(0xFF2196F3),
          autoCancel: true,
          enableVibration: true,
          playSound: true,
          visibility: NotificationVisibility.public,
        ),
      ),
      payload: payload,
    );

    print('✅ تم عرض إشعار محلي: ${notification.displayTitle}');
  }

  static void _addNotificationToService(NotificationModel notification) {
    if (Get.isRegistered<NotificationService>()) {
      final notificationService = Get.find<NotificationService>();

      if (!notificationService.notifications.any((n) => n.id == notification.id)) {
        notificationService.notifications.insert(0, notification);
        notificationService.unreadCount.value++;
        print('✅ تم إضافة الإشعار للخدمة: ${notification.title}');
      } else {
        print('ℹ️ الإشعار موجود مسبقاً في الخدمة');
      }
    }
  }

  static void _handleNotificationTap(NotificationModel notification) {
    if (Get.isRegistered<NotificationController>()) {
      final controller = Get.find<NotificationController>();

      controller.onNotificationTap(notification);

      print('✅ تم التعامل مع ضغط الإشعار: ${notification.title}');
    } else {
      Get.to(() => NotificationsScreen());
    }
  }

  static void _handleComplaintNotification(NotificationModel notification) {
    final type = notification.type?.toLowerCase() ?? '';
    final title = notification.title?.toLowerCase() ?? '';
    final body = notification.body?.toLowerCase() ?? '';

    const complaintUpdateTypes = [
      'complaint',
      'status',
      'update',
      'مشكوى',
      'حالة',
      'تحديث',
    ];

    bool isComplaintUpdate = complaintUpdateTypes.any((keyword) =>
    type.contains(keyword) ||
        title.contains(keyword) ||
        body.contains(keyword)
    );

    final hasComplaintId = notification.complaintId != null;

    if (isComplaintUpdate || hasComplaintId) {
      print('🔄 إشعار بتحديث شكوى - جاري تحديث قائمة الشكاوى...');

      if (Get.isRegistered<UserComplaintController>()) {
        final controller = Get.find<UserComplaintController>();

        controller.refreshComplaints();

        print('✅ تم تحديث قائمة الشكاوى بناءً على الإشعار الوارد');
      }

    }
  }
}