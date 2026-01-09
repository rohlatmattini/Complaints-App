import 'package:complaints/modules/complaint/view/complaint_info_reply_screen.dart';
import 'package:get/get.dart';
import '../../modules/auth/view/email_verification.dart';
import '../../modules/auth/view/forgot_password.dart';
import '../../modules/auth/view/reset_password.dart';
import '../../modules/auth/view/signin.dart';
import '../../modules/auth/view/signup.dart';
import '../../modules/complaint/view/complaint_details_screen..dart';
import '../../modules/complaint/view/new_complaint.dart';
import '../../modules/complaint/view/user_complaint_screen.dart';
import '../../modules/notification/view/notification_screen.dart';
import '../../modules/onboarding/view/onboarding.dart';
import '../../modules/setting/view/setting_secreen.dart';
import '../bindings/complaint_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoute.onboarding, page: () => OnBoarding()),
    GetPage(name: AppRoute.login, page: () => SignInScreen()),
    GetPage(name: AppRoute.signUp, page: () => SignUpScreen()),
    // GetPage(name: AppRoute.home, page: () => HomePageScreen()),
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
    GetPage(name: AppRoute.edit_complaint, page: () => ComplaintInfoReplyScreen()),

    GetPage(
      name: AppRoute.complaintDetails,
      page: () => ComplaintDetailsScreen(
        complaintId: Get.arguments as int,
      ),
    ),

  ];
}
