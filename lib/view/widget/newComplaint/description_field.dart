import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/shared/custom_text_form_field.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_form_controller.dart';

class DescriptionField extends StatelessWidget {

  const DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();

    return CustomTextFormField(
      controller: formController.descriptionController,
      label: 'Description'.tr,
      hint: 'Explain the problem in detail'.tr,
      keyboardType: TextInputType.multiline,
      validator: formController.validateDescription,
      prefixIcon: Icons.description,
      onChanged: formController.updateDescription,
    );
  }
}