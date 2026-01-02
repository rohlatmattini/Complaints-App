import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/appcolor.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: AppColor.backgroundColor,
    cardColor: AppColor.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColor.textColor),
      bodyMedium: TextStyle(color: AppColor.subtitleColor),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.headerBlue,
      foregroundColor: AppColor.white,
    ),
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColor.darkPrimary,
    scaffoldBackgroundColor: AppColor.darkBackground,
    cardColor: AppColor.darkSurface,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColor.darkText),
      bodyMedium: TextStyle(color: AppColor.darkSubtitle),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.darkHeaderBlue,
      foregroundColor: AppColor.darkText,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPreferences();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
    saveThemeToPreferences();
  }

  void saveThemeToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode.value);
  }

  void loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
  }
}
