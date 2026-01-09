import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/appcolor.dart';
import '../controller/edit_comlpaint/complaint_info_reply_controller.dart';
import '../widget/edit_complaint/message_field.dart';
import '../widget/new_complaint/attachments_section.dart';


class ComplaintInfoReplyScreen extends StatelessWidget {
  const ComplaintInfoReplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Provide Additional Information'.tr),
        backgroundColor: isDark?AppColor.darkBlueGrey:AppColor.blue,
      ),
      body: GetBuilder<ComplaintInfoReplyController>(
        init: ComplaintInfoReplyController(),
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Complaint Info Card
                // _buildComplaintInfoCard(context,controller),
                SizedBox(height: 20.h),

                // Message Field
                MessageField(
                  controller: controller.messageController,
                  label: 'Your Response Message'.tr,
                  hint: 'Please provide the requested information here...'.tr,
                  maxLines: 8,
                  validator: (value) {
                    if (controller.attachmentController.attachedFiles.isEmpty &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Please provide a message or attach files'.tr;
                    }
                    if (value != null && value.trim().length < 10) {
                      return 'Message should be at least 10 characters'.tr;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                // Attachments Section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AttachmentsSection(),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                SizedBox(height: 20.h),
                Obx(() => _buildSubmitButton(context,controller)),

                // Cancel Button
                SizedBox(height: 10.h),
                _buildCancelButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 45.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColor.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () => Get.back(),
        child: Text(
          'Cancel'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColor.grey,
          ),
        ),
      ),
    );
  }



  Widget _buildSubmitButton(BuildContext context,ComplaintInfoReplyController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark?AppColor.bluegrey:AppColor.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 3,
        ),
        onPressed: controller.isLoading.value ? null : () {
          if (controller.messageController.text.trim().isEmpty &&
              controller.attachmentController.attachedFiles.isEmpty) {
            Get.snackbar(
              'Error'.tr,
              'Please provide a message or attach files'.tr,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }
          controller.submitAdditionalInfo();
        },
        child: controller.isLoading.value
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Submit Information'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,

              ),
            ),
          ],
        ),
      ),
    );
  }
}