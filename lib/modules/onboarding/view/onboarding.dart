import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/appcolor.dart';
import '../controller/onboarding_controller.dart';
import '../widget/custombutton.dart';
import '../widget/customdotscontroller.dart';
import '../widget/customslider.dart';


class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingControllerImp());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              const Expanded(flex: 3, child: CustomSliderOnBoarding()),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const CustomDotControllerOnBoarding(),
                    SizedBox(height: 40.h),
                    CustomButton(
                      text: "Next",
                      onPressed: controller.next,
                      width: 200.w,
                      height: 50.h,
                      color: AppColor.blue,
                      borderRadius: 20.r,
                      textColor: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
