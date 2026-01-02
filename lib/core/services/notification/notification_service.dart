//
//
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:complaints/core/constant/app_links.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationService extends GetxService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//   late SharedPreferences _prefs;
//   final String _tokenKey = 'fcm_token_sent';
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     print('📱 NotificationService initialized');
//     await init();
//   }
//
//   Future<void> init() async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
//       await _setupFCM();
//     } catch (e) {
//       print('خطأ في تهيئة NotificationService: $e');
//     }
//   }
//
//   Future<void> _setupFCM() async {
//     try {
//       // طلب الإذن
//       NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//
//       print('إذن الإشعارات: ${settings.authorizationStatus}');
//
//       // الحصول على التوكن
//       String? token = await _firebaseMessaging.getToken();
//       print('FCM Token: $token');
//
//       if (token != null) {
//         await _sendTokenToServer(token);
//       }
//
//       // استماع لتحديثات التوكن
//       _firebaseMessaging.onTokenRefresh.listen((newToken) {
//         print('تم تحديث التوكن: $newToken');
//         _sendTokenToServer(newToken);
//       });
//
//     } catch (e) {
//       print('خطأ في إعداد FCM: $e');
//     }
//   }
//
//   Future<void> _sendTokenToServer(String token) async {
//     try {
//       // التحقق إذا تم إرسال التوكن مسبقاً
//       String? lastSentToken = _prefs.getString(_tokenKey);
//       if (lastSentToken == token) {
//         print('التوكن تم إرساله مسبقاً');
//         return;
//       }
//
//       // الحصول على توكن المستخدم من Secure Storage
//       String? userToken = await _secureStorage.read(key: 'token');
//
//       print('User Token from secure storage: ${userToken != null ? "Exists" : "Not found"}');
//
//       if (userToken == null || userToken.isEmpty) {
//         print('⚠️ لم يتم تسجيل الدخول بعد، سيتم تأجيل إرسال التوكن');
//         await _prefs.setString('pending_fcm_token', token);
//         return;
//       }
//
//       print('🔄 إرسال FCM token إلى الخادم...');
//
//       final response = await http.post(
//         Uri.parse(AppLinks.deviceTokens),
//         headers: {
//           'Accept': 'application/json',
//           'Accept-Language': 'ar',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $userToken',
//         },
//         body: json.encode({
//           'fcm_token': token,
//           'platform': 'android',
//         }),
//       );
//
//       print('📡 استجابة الخادم: ${response.statusCode}');
//       print('📡 محتوى الاستجابة: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // حفظ التوكن بعد الإرسال الناجح
//         await _prefs.setString(_tokenKey, token);
//         await _prefs.remove('pending_fcm_token');
//         print('✅ تم تسجيل التوكن بنجاح');
//       } else {
//         print('❌ فشل تسجيل التوكن: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('❌ خطأ في إرسال التوكن: $e');
//     }
//   }
//
//   // دالة لمعالجة التوكن المعلق بعد تسجيل الدخول
//   Future<void> sendPendingToken() async {
//     String? pendingToken = _prefs.getString('pending_fcm_token');
//     if (pendingToken != null) {
//       print('🔄 إرسال التوكن المعلق: $pendingToken');
//       await _sendTokenToServer(pendingToken);
//     } else {
//       print('ℹ️ لا يوجد توكن معلق لإرساله');
//     }
//   }
//
//   Future<void> logout() async {
//     // إزالة التوكن عند تسجيل الخروج
//     await _prefs.remove(_tokenKey);
//     await _prefs.remove('pending_fcm_token');
//     await _secureStorage.delete(key: 'token');
//   }
// }


// lib/core/services/notification/notification_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/notification/notification_model.dart';
import '../../constants/app_links.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late SharedPreferences _prefs;
  final String _tokenKey = 'fcm_token_sent';

  // متغيرات تفاعلية للإشعارات
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    print('📱 NotificationService initialized');
    await init();
    await loadUnreadCount();
    await fetchNotifications();
    onNewNotificationReceived();
    //////
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 إشعار جديد (Foreground)');

      handleIncomingNotification(message);
    });
  }

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await setupFCM(); // تم تغيير الاسم من _setupFCM إلى setupFCM
    } catch (e) {
      print('خطأ في تهيئة NotificationService: $e');
    }
  }

  // تم تغيير الاسم من _setupFCM إلى setupFCM
  Future<void> setupFCM() async {
    try {
      // طلب الإذن
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('إذن الإشعارات: ${settings.authorizationStatus}');

      // الحصول على التوكن
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      if (token != null) {
        await sendTokenToServer(token); // تم تغيير الاسم
      }

      // استماع لتحديثات التوكن
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('تم تحديث التوكن: $newToken');
        sendTokenToServer(newToken); // تم تغيير الاسم
      });

    } catch (e) {
      print('خطأ في إعداد FCM: $e');
    }
  }

  // تم تغيير الاسم من _sendTokenToServer إلى sendTokenToServer
  Future<void> sendTokenToServer(String token) async {
    try {
      // التحقق إذا تم إرسال التوكن مسبقاً
      String? lastSentToken = _prefs.getString(_tokenKey);
      if (lastSentToken == token) {
        print('التوكن تم إرساله مسبقاً');
        return;
      }

      // الحصول على توكن المستخدم من Secure Storage
      String? userToken = await _secureStorage.read(key: 'token');

      print('User Token from secure storage: ${userToken != null ? "Exists" : "Not found"}');

      if (userToken == null || userToken.isEmpty) {
        print('⚠️ لم يتم تسجيل الدخول بعد، سيتم تأجيل إرسال التوكن');
        await _prefs.setString('pending_fcm_token', token);
        return;
      }

      print('🔄 إرسال FCM token إلى الخادم...');
      final response = await http.post(
        Uri.parse('${AppLinks.baseUrl}/device-tokens'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'ar',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: json.encode({
          'fcm_token': token,
          'platform': 'android',
        }),
      );

      print('📡 استجابة الخادم: ${response.statusCode}');
      print('📡 محتوى الاستجابة: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // حفظ التوكن بعد الإرسال الناجح
        await _prefs.setString(_tokenKey, token);
        await _prefs.remove('pending_fcm_token');
        print('✅ تم تسجيل التوكن بنجاح');
      } else {
        print('❌ فشل تسجيل التوكن: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ خطأ في إرسال التوكن: $e');
    }
  }

  // دالة لمعالجة التوكن المعلق بعد تسجيل الدخول
  Future<void> sendPendingToken() async {
    String? pendingToken = _prefs.getString('pending_fcm_token');
    if (pendingToken != null) {
      print('🔄 إرسال التوكن المعلق: $pendingToken');
      await sendTokenToServer(pendingToken); // تم تغيير الاسم
    } else {
      print('ℹ️ لا يوجد توكن معلق لإرساله');
    }
  }

  // ==================== الـ APIs الجديدة ====================

  /// 1. جلب جميع الإشعارات مع pagination
  Future<List<NotificationModel>> fetchNotifications({
    int page = 1,
    int perPage = 10,
    String? status, // 'read' أو 'unread'
  }) async {
    try {
      isLoading.value = true;

      String? userToken = await _secureStorage.read(key: 'token');
      if (userToken == null) return [];

      // بناء الرابط مع query parameters
      Uri uri = Uri.parse('${AppLinks.baseUrl}/notifications').replace(
        queryParameters: {
          'page': page.toString(),
          'per_page': perPage.toString(),
          if (status != null) 'status': status,
        },
      );

      print('🔍 جلب الإشعارات من: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // تحديث بيانات الـ pagination
        currentPage.value = data['meta']['current_page'];
        totalPages.value = data['meta']['last_page'];

        // تحويل البيانات إلى نموذج
        List<NotificationModel> fetchedNotifications = [];
        for (var item in data['data']) {
          fetchedNotifications.add(NotificationModel.fromJson(item));
        }

        notifications.value = fetchedNotifications;
        print('✅ تم جلب ${fetchedNotifications.length} إشعار');
        return fetchedNotifications;
      } else {
        print('❌ فشل جلب الإشعارات: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ خطأ في جلب الإشعارات: $e');
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. جلب عدد الإشعارات غير المقروءة
  Future<int> loadUnreadCount() async {
    try {
      String? userToken = await _secureStorage.read(key: 'token');
      if (userToken == null) {
        unreadCount.value = 0;
        return 0;
      }
      final response = await http.get(
        Uri.parse('${AppLinks.baseUrl}/notifications/unread-count'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        unreadCount.value = data['unread_count'] ?? 0;
        print('🔔 عدد الإشعارات غير المقروءة: ${unreadCount.value}');
        return unreadCount.value;
      } else {
        print('❌ فشل جلب عدد الإشعارات غير المقروءة');
        return 0;
      }
    } catch (e) {
      print('❌ خطأ في جلب عدد الإشعارات غير المقروءة: $e');
      return 0;
    }
  }

  /// 3. تعليم جميع الإشعارات كمقروءة
  Future<bool> markAllAsRead() async {
    try {
      String? userToken = await _secureStorage.read(key: 'token');
      if (userToken == null) return false;

      final response = await http.post(
        Uri.parse('${AppLinks.baseUrl}/notifications/read-all'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'ar',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ ${data['message']}');

        // تحديث العد المحلي
        unreadCount.value = 0;

        // تحديث حالة الإشعارات المحلية
        for (var notification in notifications) {
          notification.isRead = true;
        }
        notifications.refresh();

        return true;
      } else {
        print('❌ فشل تعليم الإشعارات كمقروءة');
        return false;
      }
    } catch (e) {
      print('❌ خطأ في تعليم الإشعارات كمقروءة: $e');
      return false;
    }
  }

  /// 4. تحديث العد تلقائيًا عند استلام إشعار جديد
  void onNewNotificationReceived() {
    // تحديث العد
    loadUnreadCount();

    // إعادة جلب الإشعارات
    fetchNotifications();
  }

  /// 5. جلب الصفحة التالية (pagination)
  Future<void> loadNextPage() async {
    if (currentPage.value < totalPages.value) {
      await fetchNotifications(page: currentPage.value + 1);
    }
  }

  /// 6. جلب الصفحة السابقة (pagination)
  Future<void> loadPreviousPage() async {
    if (currentPage.value > 1) {
      await fetchNotifications(page: currentPage.value - 1);
    }
  }

  Future<void> logout() async {
    // إزالة التوكن عند تسجيل الخروج
    await _prefs.remove(_tokenKey);
    await _prefs.remove('pending_fcm_token');
    await _secureStorage.delete(key: 'token');

    // مسح الإشعارات المحلية
    notifications.clear();
    unreadCount.value = 0;
  }

  // تعليم إشعار واحد كمقروء
  Future<bool> markAsRead(int notificationId) async {
    try {
      String? userToken = await _secureStorage.read(key: 'token');
      if (userToken == null) return false;

      final response = await http.post(
        Uri.parse('${AppLinks.baseUrl}/notifications/$notificationId/read'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'ar',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        // تحديث الإشعار المحلي
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index].isRead = true;
          notifications.refresh();
        }

        // تحديث العد المحلي
        await loadUnreadCount();

        print('✅ تم تعليم الإشعار $notificationId كمقروء');
        return true;
      } else {
        print('❌ فشل تعليم الإشعار كمقروء: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ خطأ في تعليم الإشعار كمقروء: $e');
      return false;
    }
  }

  void handleIncomingNotification(RemoteMessage message) {
    try {
      // إذا كان السيرفر يرجع ID بالإشعار
      final data = message.data;

      if (data.isNotEmpty) {
        final newNotification = NotificationModel.fromJson(data);

        // 🔥 إضافة الإشعار مباشرة أول القائمة
        notifications.insert(0, newNotification);
        notifications.refresh();

        // تحديث العدّاد
        unreadCount.value++;
      } else {
        // fallback: إذا ما في data
        loadUnreadCount();
        fetchNotifications();
      }
    } catch (e) {
      print('❌ خطأ أثناء معالجة الإشعار: $e');
      fetchNotifications();
      loadUnreadCount();
    }
  }



}