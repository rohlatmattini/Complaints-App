import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/appimageasset.dart';
import '../../../core/utils//custom_scaffold.dart';
import '../../../core/utils//custom_text_form_field.dart';
import '../../../core/constants/appcolor.dart';
import '../../../core/utils//otp_input.dart';
import '../controller/forgot_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final controller = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(
      backgroundImage: AppImageAsset.forgetImage,
      child: Column(
        children: [
          Expanded(flex:2, child: SizedBox(height: 10.h)),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.w, 10.h, 25.w, 20.h),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBlueGrey : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.resetFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.password_rounded,
                          size: 80.sp, color: AppColor.blue),

                      SizedBox(height: 20.h),

                      Text(
                        'Reset Password'.tr,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blue,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Text(
                        "Enter the 6-digit code sent to your email".tr,
                        style:
                        TextStyle(
                          fontSize: 16.sp,
                          color: isDark
                              ? AppColor.white.withOpacity(0.7)
                              : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 30.h),

                      /// ----------- OTP CODES -------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...List.generate(
                            6,
                                (index) => OtpInput(
                              controller: controller.codeInputs[index],
                              autoFocus: index == 0,
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 30.h),


                      CustomTextFormField(
                        label: "New Password".tr,
                        hint: "Enter new password".tr,
                        controller: controller.passwordController,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),

                      SizedBox(height: 20.h),

                      CustomTextFormField(
                        label: "Confirm Password".tr,
                        hint: "Re-enter new password".tr,
                        controller: controller.confirmPasswordController,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),

                      SizedBox(height: 25.h),

                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.blue,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                          ),
                          onPressed: controller.isResetting.value
                              ? null
                              : controller.resetPassword,
                          child: controller.isResetting.value
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : Text(
                            'Reset Password'.tr,
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white),
                          ),
                        ),
                      )),

                      Obx(() => TextButton(
                        onPressed: controller.isSending.value
                            ? null
                            : controller.sendResetCode,
                        child: controller.isSending.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text(
                          "Resend Code".tr,
                          style: TextStyle(
                            color: AppColor.blue,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
