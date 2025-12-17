import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasource/static/static.dart';
import '../../core/constant/app_routes.dart';

class OnBoardingControllerImp extends GetxController {
  PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  void next() {
    if (currentPage < onBoardingList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Get.toNamed(AppRoute.login);
    }
  }
}
