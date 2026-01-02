import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/appimageasset.dart';
import '../../../core/utils//custom_scaffold.dart';
import '../../../core/utils//custom_text_form_field.dart';
import '../../../core/constants/appcolor.dart';
import '../../../core/utils//otp_input.dart';
import '../controller/forgot_password_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/signin_controller.dart';
import '../widget/Remember_forgot_row.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController controller = Get.put(SignInController(), permanent: false);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(
      backgroundImage: AppImageAsset.login,
      child: Column(
        children: [
          Expanded(flex: 2, child: SizedBox(height: 10.h)),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.w, 50.h, 25.w, 20.h),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBlueGrey: Colors.white,
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
                        'Welcome back'.tr,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColor.white : AppColor.blue,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Email Field
                      CustomTextFormField(
                        label: 'Email'.tr,
                        hint: "Enter your email".tr,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: controller.validateEmail,
                      ),
                      SizedBox(height: 25.h),

                      // Password Field
                      Obx(() => CustomTextFormField(
                        label: 'Password'.tr,
                        hint: "Enter password".tr,
                        controller: controller.passwordController,
                        obscureText: controller.obscureText.value,
                        prefixIcon: Icons.lock,
                        suffixIcon: controller.obscureText.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixPressed: controller.togglePasswordVisibility,
                        validator: controller.validatePassword,
                      )),
                      SizedBox(height: 25.h),

                      // Remember / Forgot
                      Obx(() => RememberForgotRow(
                        rememberPassword: controller.rememberPassword.value,
                        onRememberChanged: controller.toggleRemember,
                        onForgotTap: () {
                          Get.toNamed(AppRoute.forgotPassword);
                        },
                      )),
                      SizedBox(height: 25.h),

                      //  Sign in Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.blue,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                          ),
                          onPressed: controller.submitForm,
                          child: Text(
                            'Sign in'.tr,
                            style: TextStyle(fontSize: 18.sp, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "if you don't have an account ?".tr,
                            style: TextStyle(
                              color: isDark ? AppColor.white : AppColor.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoute.signUp);
                            },
                            child: Text(
                              "Sign Up".tr,
                              style: TextStyle(
                                color: AppColor.blue,
                              ),
                            ),
                          )
                        ],
                      ),
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