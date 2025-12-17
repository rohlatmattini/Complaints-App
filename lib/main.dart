import 'package:complaints/view/screen/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'controller/localization/locale_controller.dart';
import 'controller/profile/user_controller.dart';
import 'controller/theme/theme_controller.dart';
import 'core/app_initializer/app_initializer.dart';
import 'core/localization/my_locale.dart';
import 'core/routes/routes_pages.dart';

SharedPreferences? sharedpref;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  Get.put(MyLocaleController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        final MyLocaleController localeController = Get.find();
        final ThemeController themeController = Get.find();


        return Obx(
          () => GetMaterialApp(

            debugShowCheckedModeBanner: false,
            // initialBinding: InitialBinding(),
            locale: localeController.currentLocale.value,
            translations: MyLocale(),
            theme: themeController.isDarkMode.value
                ? themeController.darkTheme
                : themeController.lightTheme,
            getPages: AppPages.pages,

            home: child,
          ),
        );
      },
      child: SignInScreen(),
    );
  }
}
