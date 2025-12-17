import 'dart:ui';
import 'package:get/get.dart';

import '../../main.dart';

class MyLocaleController extends GetxController {
  var currentLang = 'en'.obs;

  Rx<Locale> currentLocale = Rx<Locale>(const Locale('en'));
  @override
  void onInit() {
    super.onInit();
    String? lang = sharedpref!.getString("lang");
    if (lang != null) {
      currentLang.value = lang;
      currentLocale.value = Locale(lang);
      Get.updateLocale(currentLocale.value);
    }
  }
  void changeLang(String languageCode) {
    sharedpref!.setString("lang", languageCode);
    currentLang.value = languageCode;
    currentLocale.value = Locale(languageCode);
    Get.updateLocale(currentLocale.value);
  }
  String get currentLangFromPref => sharedpref!.getString("lang") ?? "en";


}
