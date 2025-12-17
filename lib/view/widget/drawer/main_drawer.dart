import 'package:complaints/core/constant/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/profile/user_controller.dart';
import '../../../core/constant/appcolor.dart';
import '../../../core/shared/app_row_tile.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Obx(() {
      final user = userController.user.value;

      String firstLetter = "?";
      if (user?.name != null && user!.name.isNotEmpty) {
        firstLetter = user.name[0].toUpperCase();
      }

      return Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColor.blue),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: Colors.white,
                    child: Text(
                      firstLetter,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.blue,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? "Guest",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user?.email ?? "",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AppTile(
              icon: Icons.settings,
              label: 'Settings'.tr,
              iconColor: AppColor.blue,
              onTap: () {
                Get.toNamed(AppRoute.setting);
              },
            ),

            AppTile(
              icon: Icons.notification_add,
              label: 'Notifications'.tr,
              iconColor: AppColor.blue,
              onTap: () {
                Get.back(); // إغلاق الدرور
                Get.toNamed('/notifications');
              },
            ),

            AppTile(
              icon: Icons.logout_sharp,
              label: 'Logout'.tr,
              iconColor: AppColor.blue,
              textColor: AppColor.red,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      );
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'.tr),
          content: Text('Are you sure you want to logout?'.tr),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Cancel'.tr,style: TextStyle(color: AppColor.blue),)),
            TextButton(
              onPressed: () {
                Get.find<UserController>().logout();
              },
              child: Text('Logout'.tr,style: TextStyle(color: AppColor.blue)),
            ),
          ],
        );
      },
    );
  }

  // void _performLogout() {
  //   Get.find<UserController>().clearUser();
  //   Get.offAllNamed('/login');
  // }
}
