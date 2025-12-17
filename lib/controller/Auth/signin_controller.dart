import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../core/services/Auth/api_service.dart';
import '../../core/services/Auth/user_service.dart';
import '../../core/services/notification/notification_service.dart';
import '../../data/model/Auth/login.dart';
import '../../core/constant/app_routes.dart';
import '../../data/model/Auth/user.dart';

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
        Get.toNamed(AppRoute.userComplaints);
      } else {
        Get.snackbar(
          'Error'.tr,
          'Your email is not verified. Please verify first.'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    // Get.snackbar(
    //   'Error',
    //   response?['message'] ?? 'Login failed',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
}
