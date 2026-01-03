import 'package:complaints/modules/auth/controller/signin_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth/api_service.dart';
import '../../../core/services/auth/user_service.dart';
import '../../../data/models/Auth/user.dart';


class UserController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadUser();

  }

  void loadUser() async {
    user.value = await UserService().getUser();
  }

  void logout() async {
    final token = await const FlutterSecureStorage().read(key: 'token');

    if (token != null) {
      final response = await apiService.logout(token);

      if (response != null) {
        await UserService().clearUser();
        await const FlutterSecureStorage().delete(key: 'token');

        user.value = null;

        if (Get.isRegistered<SignInController>()) {
          Get.delete<SignInController>();
        }

        Get.offAllNamed(AppRoute.login);
      }
    }
  }

}
