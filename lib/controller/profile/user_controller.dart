import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../core/constant/app_routes.dart';
import '../../core/services/Auth/api_service.dart';
import '../../core/services/Auth/user_service.dart';
import '../../data/model/Auth/user.dart';
import '../Auth/signin_controller.dart';

class UserController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    loadUser();
    super.onInit();
  }

  void loadUser() async {
    user.value = await UserService().getUser();
  }

  void logout() async {
    final token = await const FlutterSecureStorage().read(key: 'token');

    if (token != null) {
      final response = await apiService.logout(token);

      if (response != null) {
        // 🧹 مسح البيانات المخزنة
        await UserService().clearUser();
        await const FlutterSecureStorage().delete(key: 'token');

        // 🧹 تصفير المستخدم داخل الـ Controller
        user.value = null;

        // 🧹 حذف SignInController حتى لا تتكرر GlobalKey
        if (Get.isRegistered<SignInController>()) {
          Get.delete<SignInController>();
        }

        // 🔁 الرجوع للـ login بشكل نظيف
        Get.offAllNamed(AppRoute.login);
      }
    }
  }

}
