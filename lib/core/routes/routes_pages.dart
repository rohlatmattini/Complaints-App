import 'package:get/get.dart';
import '../../view/screen/complaint/complaint_details_screen..dart';
import '../../view/screen/notification/notification_screen.dart';
import '../app_initializer/complaint_binding.dart';
import '../constant/app_routes.dart';

// Import Screens
import 'package:complaints/view/screen/auth/signin.dart';
import 'package:complaints/view/screen/auth/signup.dart';
import 'package:complaints/view/screen/onboarding.dart';
import 'package:complaints/view/screen/home_page.dart';
import 'package:complaints/view/screen/complaint/new_complaint.dart';
import 'package:complaints/view/screen/complaint/user_complaint_screen.dart';
import 'package:complaints/view/screen/setting/setting_secreen.dart';
import 'package:complaints/view/screen/auth/email_verification.dart';
import 'package:complaints/view/screen/auth/forgot_password.dart';
import 'package:complaints/view/screen/auth/reset_password.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoute.onboarding, page: () => OnBoarding()),
    GetPage(name: AppRoute.login, page: () => SignInScreen()),
    GetPage(name: AppRoute.signUp, page: () => SignUpScreen()),
    GetPage(name: AppRoute.home, page: () => HomePageScreen()),
    GetPage(
      name: AppRoute.addNewComplaint,
      page: () => NewComplaintScreen(),
      binding: ComplaintBinding(),
    ),
    GetPage(name: AppRoute.userComplaints, page: () => UserComplaintsScreen(),binding: ComplaintBinding(),
    ),
    GetPage(name: AppRoute.setting, page: () => SettingScreen()),
    GetPage(
      name: AppRoute.emailVerification,
      page: () => EmailVerificationScreen(),
    ),
    GetPage(name: AppRoute.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoute.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: AppRoute.notifications, page: () => NotificationsScreen()),
    GetPage(
      name: AppRoute.complaintDetails,
      page: () => ComplaintDetailsScreen(
        complaintId: Get.arguments as int,
      ),
    ),

  ];
}
