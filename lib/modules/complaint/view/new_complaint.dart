import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/appcolor.dart';
import '../../../core/constants/appimageasset.dart';
import '../../../core/utils/custom_scaffold.dart';
import '../controller/new_complaint_controller/complaint_form_controller.dart';
import '../controller/new_complaint_controller/complaint_submission_controller.dart';
import '../widget/new_complaint/attachments_section.dart';
import '../widget/new_complaint/complaint_type_dropdown.dart';
import '../widget/new_complaint/description_field.dart';
import '../widget/new_complaint/region_dropdown.dart';
import '../widget/new_complaint/responsible_entity_dropdown.dart';
import '../widget/new_complaint/title_field.dart';


class NewComplaintScreen extends StatelessWidget {
  const NewComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final formController = Get.find<ComplaintFormController>();
    final submissionController = Get.find<ComplaintSubmissionController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(

      backgroundImage: AppImageAsset.complaintImage,
      child: Column(
        children: [
           Expanded(flex: 1, child: SizedBox(height: 10.h)),

          Expanded(
            flex: 7,
            child: Container(
              padding:  EdgeInsets.fromLTRB(25.w, 40.h, 25.w, 20.h),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'submit_complaint_title'.tr,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color:isDark?AppColor.white:AppColor.blue,
                        ),
                      ),
                       SizedBox(height: 20.h),

                      TitleField(),
                      SizedBox(height: 20.h),

                      ComplaintTypeDropdown(),
                      SizedBox(height: 20.h),

                      ResponsibleEntityDropdown(),
                      SizedBox(height: 20.h),


                      DescriptionField(),
                      SizedBox(height: 20.h),

                      RegionDropdown( ),

                      SizedBox(height: 20.h),

                      AttachmentsSection(),
                      SizedBox(height: 20.h),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark?AppColor.bluegrey:AppColor.blue,
                            padding:  EdgeInsets.symmetric(vertical: 15.h),
                          ),
                          onPressed: submissionController.submitComplaint,
                          icon: const Icon(Icons.send, color: AppColor.white),
                          label: Text(
                            'submit_complaint_button'.tr,
                            style:  TextStyle(fontSize: 18.sp, color: AppColor.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}