import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/services/Auth/api_service.dart';
import '../../core/constant/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final ApiService api = ApiService();

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isSending = false.obs;
  RxBool isResetting = false.obs;

  final forgotFormKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();

  // VALIDATION
  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return "Enter email".tr;
    if (!GetUtils.isEmail(v)) return "Invalid email".tr;
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return "Enter password".tr;
    if (v.length < 8) return "Minimum 8 chars".tr;
    return null;
  }

  List<TextEditingController> codeInputs = List.generate(
    6,
    (index) => TextEditingController(),
  );

  String get enteredCode => codeInputs.map((c) => c.text).join();

  // REQUEST RESET CODE
  void sendResetCode() async {
    if (!forgotFormKey.currentState!.validate()) return;

    isSending.value = true;

    final response = await api.forgotPassword(emailController.text.trim());

    isSending.value = false;

    if (response != null) {
      Get.snackbar("Success", response["message"] ?? "Code sent");
      Get.toNamed(AppRoute.resetPassword);
    } else {
      Get.snackbar("Error".tr, "Something went wrong".tr);
    }
  }

  // RESET PASSWORD
  void resetPassword() async {
    if (!resetFormKey.currentState!.validate()) return;

    isResetting.value = true;

    final res = await api.resetPassword(
      email: emailController.text.trim(),
      code: enteredCode,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    isResetting.value = false;

    if (res != null && !res.containsKey("errors")) {
      Get.snackbar("Success".tr, "Password updated successfully".tr);
      Get.toNamed(AppRoute.userComplaints);
    } else {
      Get.snackbar("Error", res?["message"] ?? "Wrong code");
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
}
