import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../core/services/Auth/api_service.dart';
import '../../core/services/Auth/user_service.dart';
import '../../core/services/notification/notification_service.dart';
import '../../data/model/Auth/signup.dart';
import '../../core/constant/app_routes.dart';
import '../../data/model/Auth/user.dart';
import '../../view/screen/auth/email_verification.dart';

class SignUpController extends GetxController {
  // Form keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> verifyFormKey = GlobalKey<FormState>();

  // API service & storage
  final ApiService apiService = ApiService();
  final storage = const FlutterSecureStorage();

  // Loading states
  var isLoading = false.obs;
  var isVerifying = false.obs;

  // Text controllers
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final verificationCodeController = TextEditingController();

  // Password visibility
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Validation methods
  String? validateUserName(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) return 'Please enter your name';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) return 'Please enter your phone number'.tr;
    if (!GetUtils.isPhoneNumber(value)) return 'Invalid phone number'.tr;
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) return 'Please enter your email'.tr;
    if (!GetUtils.isEmail(value)) return 'Invalid email format'.tr;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password'.tr;
    if (value.length < 8) return 'Password must be at least 8 characters'.tr;
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) return 'Passwords do not match.tr';
    return null;
  }

  String? validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) return 'Enter verification code'.tr;
    if (value.length != 6) return 'Code must be 6 digits'.tr;
    return null;
  }


  List<TextEditingController> codeInputs = List.generate(
    6,
        (index) => TextEditingController(),
  );

  String get enteredCode => codeInputs.map((c) => c.text).join();

  // Register & navigate to verification
  void submitForm() async {
    if (!formKey.currentState!.validate()) return;

    final signUpData = SignUpModel(
      userName: userNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = true;

    final response = await apiService.register(signUpData);

    isLoading.value = false;

    if (response != null) {
      // استخرج التوكن من data
      final token = response['data']?['token'];

      if (token != null) {
        // تخزين التوكن بشكل آمن
        await storage.write(key: 'token', value: token);


        try {
          final notificationService = Get.find<NotificationService>();
          await notificationService.sendPendingToken();
          print('✅ تم محاولة إرسال التوكن المعلق بعد التسجيل');
        } catch (e) {
          print('⚠️ خطأ في إرسال التوكن المعلق: $e');
        }



        final user = UserModel(
          name: userNameController.text.trim(),
          email: emailController.text.trim(),
        );

        await UserService().saveUser(user);
        print("Token saved: $token");

        Get.to(() => EmailVerificationScreen());

        Get.snackbar(
          'Almost Done'.tr,
          'A verification code has been sent to your email.'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );

      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Unknown error',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error'.tr,
        'Something went wrong'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Verify email
  void verifyEmailCode() async {
    if (enteredCode.length != 6) {
      Get.snackbar(
        "Error".tr,
        "Please enter the complete 6-digit code".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isVerifying.value = true;

    final token = await storage.read(key: 'token');

    if (token == null) {
      Get.snackbar(
        "Error".tr,
        "Token not found. Please sign up again.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      isVerifying.value = false;
      return;
    }

    final response = await apiService.verifyEmail(enteredCode, token);

    isVerifying.value = false;

    if (response != null) {
      print("VERIFY RESPONSE => $response");

      final emailVerified = response['data']?['email_verified'] ?? false;

      if (emailVerified) {
        Get.snackbar(
          "Success",
          "Email verified successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(AppRoute.userComplaints);
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Wrong code",
          snackPosition: SnackPosition.BOTTOM,
        );
        clearOtpFields();
      }
    } else {
      Get.snackbar(
        "Error".tr,
        "Something went wrong".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      clearOtpFields();
    }
  }

  void clearOtpFields() {
    for (var controller in codeInputs) {
      controller.clear();
    }

    Future.delayed(const Duration(milliseconds: 50), () {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void resendVerificationCode() async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      Get.snackbar(
        "Error".tr,
        "Token not found. Please sign up again.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isVerifying.value = true;

    final response = await apiService.resendVerification(token);

    isVerifying.value = false;

    if (response != null) {
      Get.snackbar(
        "Success",
        response['message'] ?? "Verification code resent",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error".tr,
        "Failed to resend verification code",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }



  }





