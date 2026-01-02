import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/custom_text_form_field.dart';
import '../../controller/new_complaint_controller/complaint_form_controller.dart';

class TitleField extends StatelessWidget {
  const TitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();

    return CustomTextFormField(
      controller: formController.titleController,
      label: 'Complaint Title'.tr,
      hint: 'Enter the title'.tr,
      validator: formController.validateTitle,
      prefixIcon: Icons.title,
      onChanged: formController.updateTitle,
    );
  }
}
