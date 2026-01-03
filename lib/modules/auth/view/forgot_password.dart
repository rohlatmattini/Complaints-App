import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/appimageasset.dart';
import '../../../core/utils//custom_scaffold.dart';
import '../../../core/constants/appcolor.dart';
import '../../../core/utils//custom_text_form_field.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(
      backgroundImage: AppImageAsset.forgetImage,
      child: Column(
        children: [
          Expanded(flex: 2, child: SizedBox(height: 10.h)),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.w, 50.h, 25.w, 20.h),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBlueGrey : AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.forgotFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_reset_rounded,
                          size: 80.sp, color:isDark?AppColor.white:AppColor.blue,),

                      SizedBox(height: 20.h),

                      Text(
                        'Forgot Password'.tr,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color:isDark?AppColor.white:AppColor.blue,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Text(
                        "Enter your email to receive reset code".tr,
                        style:
                        TextStyle(
                          fontSize: 16.sp,
                          color: isDark
                              ? AppColor.white.withOpacity(0.7)
                              : Colors.grey[600],
                        ),                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 40.h),

                      CustomTextFormField(
                        label: 'Email'.tr,
                        hint: 'Enter your email'.tr,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: controller.validateEmail,
                      ),

                      SizedBox(height: 25.h),

                      Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:isDark?AppColor.bluegrey:AppColor.blue,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                            ),
                            onPressed: controller.isSending.value
                                ? null
                                : controller.sendResetCode,
                            child: controller.isSending.value
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : Text(
                              'Send Code'.tr,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white),
                            ),
                          ))),
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
