import 'package:complaints/core/constant/appcolor.dart';
import 'package:complaints/core/constant/appimageasset.dart';
import 'package:complaints/core/constant/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widget/drawer/main_drawer.dart';
import '../widget/home_page/MainButton.dart';


class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.white),
        elevation: 0,
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 70.h, horizontal: 18.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300.h,
              child: Image.asset(AppImageAsset.homePage),
            ),
             SizedBox(height: 50.h),
            MainButton(
              icon: Icons.note_add,
              label: 'New Complaint'.tr,
              onTap: () => Get.toNamed(AppRoute.addNewComplaint),
            ),
             SizedBox(height: 16.h),
            MainButton(
              icon: Icons.assignment_turned_in,
              label: 'Track Complaint'.tr,
              onTap: () => Get.toNamed(AppRoute.userComplaints),
            ),
          ],
        ),
      ),
    );
  }
}