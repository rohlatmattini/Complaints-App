import 'package:get/get.dart';
import '../../modules/complaint/controller/new_complaint_controller/complaint_attachment_controller.dart';
import '../../modules/complaint/controller/new_complaint_controller/complaint_form_controller.dart';
import '../../modules/complaint/controller/new_complaint_controller/complaint_meta_controller.dart';
import '../../modules/complaint/controller/new_complaint_controller/complaint_submission_controller.dart';
import '../../modules/complaint/controller/user_complaint_controller/user_complaint_controller.dart';

class ComplaintBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => UserComplaintController());
    Get.lazyPut(() => ComplaintFormController());
    Get.lazyPut(() => ComplaintAttachmentController());
    Get.lazyPut(() => ComplaintMetaController());
    Get.lazyPut(() => ComplaintSubmissionController());
  }
}