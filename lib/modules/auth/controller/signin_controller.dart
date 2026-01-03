import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth/api_service.dart';
import '../../../core/services/auth/user_service.dart';
import '../../../core/services/notification/notification_service.dart';
import '../../../data/models/Auth/login.dart';
import '../../../data/models/Auth/user.dart';


class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool obscureText = true.obs;
  RxBool rememberPassword = true.obs;
  var isLoading = false.obs;

  final storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  DateTime lastAttempt = DateTime.now().subtract(Duration(seconds: 5));
  RxInt secondsRemaining = 0.obs;
  Timer? timer;


  void startTimer(int seconds) {
    secondsRemaining.value = seconds;
    timer?.cancel(); // إلغاء أي تاييمر قديم
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        t.cancel();
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
  void togglePasswordVisibility() => obscureText.value = !obscureText.value;

  void toggleRemember(bool? value) => rememberPassword.value = value ?? false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email'.tr;
    if (!GetUtils.isEmail(value)) return 'Invalid email format'.tr;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password'.tr;
    if (value.length < 6) return 'Password must be at least 6 characters'.tr;
    return null;
  }

  // Login API call
  void submitForm() async {
    if (!formKey.currentState!.validate()) return;
    if (secondsRemaining.value > 0) {
      Get.snackbar('Wait'.tr, '${'Please wait'.tr} ${secondsRemaining.value} ${'seconds'.tr}');
      return;
    }
    isLoading.value = true;

    final model = LoginModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      rememberMe: rememberPassword.value,
    );

    final response = await apiService.login(model);

    isLoading.value = false;

    if (response != null && response['data'] != null) {
      final token = response['data']['token'];
      final emailVerified = response['data']['user']['email_verified'] ?? false;

      if (token != null) {
        await storage.write(key: 'token', value: token);
      }
      if (rememberPassword.value) {
        await storage.write(key: 'isLoggedIn', value: 'true');
      } else {
        await storage.write(key: 'isLoggedIn', value: 'false');
      }

      final userData = response['data']['user'];

      final user = UserModel(
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
      );

      //   حفظ بيانات المستخدم
      await UserService().saveUser(user);


      if (emailVerified) {
        try {
          final notificationService = Get.find<NotificationService>();
          await notificationService.sendPendingToken();
          print('✅ تم محاولة إرسال التوكن المعلق');
        } catch (e) {
          print('⚠️ خطأ في إرسال التوكن المعلق: $e');
        }

        Get.snackbar(
          'Success'.tr,
          'Login successful'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoute.userComplaints);
      } else {
        Get.snackbar(
          'Error'.tr,
          'Your email is not verified. Please verify first.'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    else {
      String message = response?['message'] ?? 'Login failed'.tr;      if (response != null) {
        message = response['message'] ?? message;

        if (response['errors'] != null && response['errors']['email'] != null) {
          message = response['errors']['email'][0];
        }
      }
      final regExp = RegExp(r'[-+]?(\d+(\.\d+)?)');
      final match = regExp.firstMatch(message);

      if (match != null) {
        double extractedValue = double.parse(match.group(0)!);

        int totalSeconds = (extractedValue.abs() * 60).toInt();

        if (totalSeconds > 0) {
          startTimer(totalSeconds);
        }
      }


      Get.snackbar(
        'Login Failed'.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }
}
