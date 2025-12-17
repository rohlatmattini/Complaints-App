import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/Auth/signup_controller.dart';
import '../../../core/constant/appcolor.dart';
import '../../../core/shared/otp_input.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.find<SignUpController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25.w),
          child: Form(
            key: controller.verifyFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Icon(
                  Icons.verified_user_outlined,
                  size: 80.sp,
                  color: AppColor.blue,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Verify Your Email'.tr,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.blue,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'We sent a verification code to'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  controller.emailController.text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blue,
                  ),
                ),
                SizedBox(height: 40.h),

                // Verification Code Fields
                Column(
                  children: [
                    Text(
                      'Enter 6-digit code'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                            (index) => OtpInput(
                          controller: controller.codeInputs[index],
                          autoFocus: index == 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),

                // Verify Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blue,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                    ),
                    onPressed: controller.isVerifying.value
                        ? null
                        : controller.verifyEmailCode,
                    child: controller.isVerifying.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Verify Email'.tr,
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                )),

                SizedBox(height: 20.h),
                TextButton(
                  onPressed: controller.resendVerificationCode,
                  child: Text(
                    "Resend Code".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Back to Sign Up
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "Back to Sign Up".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}