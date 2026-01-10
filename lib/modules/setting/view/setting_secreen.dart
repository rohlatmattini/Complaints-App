import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme/theme_controller.dart';
import '../../../core/constants/appcolor.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/utils/app_row_tile.dart';


class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyLocaleController controllerlang = Get.find();
    final ThemeController themecontroller = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark?AppColor.darkBlueGrey:AppColor.blue,
        title: Text(
          "Settings".tr,
          style: TextStyle(
            color: AppColor.white,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.only(top: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            AppTile(
              icon: Icons.dark_mode_rounded,
              iconColor: isDark ? Colors.white : AppColor.blue,
              label: "Dark mode".tr,
              onTap: () {},
              trailing: Obx(() => Switch(
                value: themecontroller.isDarkMode.value,
                onChanged: (state) => themecontroller.toggleTheme(),
                activeColor: isDark ? Colors.white : AppColor.blue,
              )),
            ),

             SizedBox(height: 5.h),


            AppTile(
              icon: Icons.language,
              iconColor: isDark ? Colors.white : AppColor.blue,
              label: "Language".tr,
              onTap: () {},
              trailing: Obx(() => DropdownButton<String>(
                value: controllerlang.currentLang.value,
                underline: const SizedBox(),
                icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white : AppColor.blue),
                items: [
                  DropdownMenuItem(
                    value: "en",
                    child: Text("En".tr),
                  ),
                  DropdownMenuItem(
                    value: "ar",
                    child: Text("Ar".tr),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) controllerlang.changeLang(value);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
