import 'dart:convert';
import 'dart:math';
import 'package:complaints/controller/notification/notification_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/complaint/user_complaint_controller/user_complaint_controller.dart';
import '../../controller/localization/locale_controller.dart';
import '../../controller/profile/user_controller.dart';
import '../../controller/theme/theme_controller.dart';
import '../../data/model/notification/notification_model.dart';
import '../../main.dart';
import 'package:flutter/material.dart';

import '../../view/screen/notification/notification_screen.dart';
import '../events/complaint_event_bus.dart';
import '../services/notification/notification_service.dart';

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

    // Get FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN -----------------------------------: $token");

    // Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("📩 رسالة أمامية: ${message.notification?.title}");

      // إنشاء NotificationModel من البيانات المستقبلة
      final notification = await _createNotificationModelFromMessage(message);

      // عرض إشعار محلي بالمعلومات الكاملة
      await _showLocalNotification(notification);

      // إضافة الإشعار للـ NotificationService
      _addNotificationToService(notification);


      // تحديث شاشة الشكاوى إذا كان الإشعار يتعلق بتغيير حالة شكوى
      _handleComplaintNotification(notification);


    });

    // Listener عند فتح التطبيق من الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("🚀 المستخدم فتح التطبيق من إشعار");

      // إنشاء NotificationModel
      final notification = await _createNotificationModelFromMessage(message);

      // إضافة الإشعار للخدمة
      _addNotificationToService(notification);

      // تحديث شاشة الشكاوى
      _handleComplaintNotification(notification);


      // فتح الصفحة المناسبة
      _handleNotificationTap(notification);
    });

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Controllers
    Get.put(MyLocaleController());
    Get.put(ThemeController());
    Get.put(UserController());
    Get.put(NotificationService());
    Get.put(NotificationController());
  }

  // ==================== الدوال المساعدة ====================

  // دالة لإنشاء NotificationModel من الرسالة
  static Future<NotificationModel> _createNotificationModelFromMessage(
      RemoteMessage message) async {
    // إنشاء ID فريد للإشعار
    int notificationId = message.data['id'] != null
        ? int.tryParse(message.data['id'].toString()) ?? Random().nextInt(100000)
        : Random().nextInt(100000);

    // الحصول على بيانات الرسالة
    final title = message.notification?.title ?? 'إشعار جديد';
    final body = message.notification?.body ?? '';
    final type = message.data['type'] ?? 'general';
    final data = message.data;

    // إنشاء الـ NotificationModel
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

  // دالة لعرض الإشعار المحلي
  static Future<void> _showLocalNotification(NotificationModel notification) async {
    // استخدام النص الكامل للإشعار
    final notificationText = notification.getNotificationSummary();
    final complaintInfo = notification.getComplaintInfo();

    // إعداد payload للتنقل عند الضغط على الإشعار
    final payload = json.encode({
      'notification_id': notification.id,
      'type': notification.type,
      'complaint_id': notification.complaintId,
      'title': notification.title,
    });

    // بناء النص الكامل مع معلومات الشكوى
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

  // دالة لإضافة الإشعار للـ NotificationService
  static void _addNotificationToService(NotificationModel notification) {
    if (Get.isRegistered<NotificationService>()) {
      final notificationService = Get.find<NotificationService>();

      // تحقق إذا الإشعار موجود مسبقاً
      if (!notificationService.notifications.any((n) => n.id == notification.id)) {
        // إضافة الإشعار في بداية القائمة
        notificationService.notifications.insert(0, notification);
        notificationService.unreadCount.value++;
        print('✅ تم إضافة الإشعار للخدمة: ${notification.title}');
      } else {
        print('ℹ️ الإشعار موجود مسبقاً في الخدمة');
      }
    }
  }

  // دالة للتعامل مع الضغط على الإشعار
  static void _handleNotificationTap(NotificationModel notification) {
    if (Get.isRegistered<NotificationController>()) {
      final controller = Get.find<NotificationController>();

      // تحديث حالة الإشعار كمقروء
      controller.onNotificationTap(notification);

      print('✅ تم التعامل مع ضغط الإشعار: ${notification.title}');
    } else {
      Get.to(() => NotificationsScreen());
    }
  }

  static void _handleComplaintNotification(NotificationModel notification) {
    // التحقق إذا كان الإشعار يتعلق بتغيير حالة شكوى
    final type = notification.type?.toLowerCase() ?? '';
    final title = notification.title?.toLowerCase() ?? '';
    final body = notification.body?.toLowerCase() ?? '';

    // قائمة الأنواع التي تشير إلى تحديث حالة الشكوى
    const complaintUpdateTypes = [
      'complaint',          // شكوى
      'status',             // حالة
      'update',             // تحديث
      'مشكوى',              // عربي
      'حالة',               // عربي
      'تحديث',              // عربي
    ];

    // التحقق من وجود كلمات مفتاحية تدل على تحديث شكوى
    bool isComplaintUpdate = complaintUpdateTypes.any((keyword) =>
    type.contains(keyword) ||
        title.contains(keyword) ||
        body.contains(keyword)
    );

    // أو التحقق من وجود complaint_id في البيانات
    final hasComplaintId = notification.complaintId != null;

    if (isComplaintUpdate || hasComplaintId) {
      print('🔄 إشعار بتحديث شكوى - جاري تحديث قائمة الشكاوى...');

      // إطلاق event لتحديث الشكاوى
      if (Get.isRegistered<UserComplaintController>()) {
        final controller = Get.find<UserComplaintController>();

        // تحديث فوري للشكاوى
        controller.refreshComplaints();

        print('✅ تم تحديث قائمة الشكاوى بناءً على الإشعار الوارد');
      }
      // else if (Get.isRegistered<ComplaintEvents>()) {
      //   // أو استخدام event bus إذا كان متاحاً
      //   ComplaintEvents.refreshAll();
      // }
    }
  }
}