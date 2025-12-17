import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/Auth/signup_controller.dart';
import '../../../core/constant/appcolor.dart';
import '../../../core/constant/appimageasset.dart';
import '../../../core/shared/custom_text_form_field.dart';
import '../../../core/shared/custom_scaffold.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(
      backgroundImage: AppImageAsset.login,
      child: Column(
        children: [
          Expanded(flex: 1, child: SizedBox(height: 10.h)),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.w, 50.h, 25.w, 20.h),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBlueGrey : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account'.tr,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColor.white : AppColor.blue,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      //  User Name
                      CustomTextFormField(
                        label: 'User Name'.tr,
                        hint: 'Enter your name'.tr,
                        controller: controller.userNameController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.person,
                        validator: controller.validateUserName,
                      ),
                      SizedBox(height: 25.h),

                      //  Phone Number
                      CustomTextFormField(
                        label: 'Phone Number'.tr,
                        hint: 'Enter your phone number'.tr,
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone,
                        validator: controller.validatePhone,
                      ),
                      SizedBox(height: 25.h),

                      // Email
                      CustomTextFormField(
                        label: 'Email'.tr,
                        hint: 'Enter your email'.tr,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: controller.validateEmail,
                      ),
                      SizedBox(height: 25.h),

                      // Password
                      Obx(() => CustomTextFormField(
                        label: 'Password'.tr,
                        hint: 'Enter password'.tr,
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        prefixIcon: Icons.lock,
                        suffixIcon: controller.obscurePassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixPressed: controller.togglePasswordVisibility,
                        validator: controller.validatePassword,
                      )),
                      SizedBox(height: 25.h),

                      //  Confirm Password
                      Obx(() => CustomTextFormField(
                        label: 'Confirm Password'.tr,
                        hint: 'Re-enter password'.tr,
                        controller: controller.confirmPasswordController,
                        obscureText: controller.obscureConfirmPassword.value,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: controller.obscureConfirmPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixPressed: controller.toggleConfirmPasswordVisibility,
                        validator: controller.validateConfirmPassword,
                      )),
                      SizedBox(height: 30.h),

                      //  Sign Up Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.blue,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                          ),
                          onPressed: controller.isLoading.value ? null : controller.submitForm,
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                            'Sign Up'.tr,
                            style: TextStyle(fontSize: 18.sp, color: Colors.white),
                          ),
                        ),
                      )),

                      SizedBox(height: 25.h),
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