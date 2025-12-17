import 'package:complaints/core/constant/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_form_controller.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_meta_controller.dart';

class ResponsibleEntityDropdown extends StatelessWidget {
  const ResponsibleEntityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();
    final metaController = Get.find<ComplaintMetaController>();

    return Obx(() {
      if (metaController.isLoading.value) {
        return _buildLoadingState();
      }

      return DropdownButtonFormField<String>(
        value: formController.complaint.value.responsibleEntity.isEmpty
            ? null
            : formController.complaint.value.responsibleEntity,
        items: metaController.responsibleEntities.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.tr),
          );
        }).toList(),
        onChanged: formController.updateResponsibleEntity,
      decoration: InputDecoration(
      hintText: 'Responsible Entity'.tr,
        hintStyle: TextStyle(color: AppColor.blue),
      border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColor.blue, width: 2),
      ),
      ),
        validator: formController.validateResponsibleEntity,
      );
    });
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),

      ),


      child: Row(
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: 12.w),
          Text('Loading responsible entities...'.tr),
        ],
      ),
    );
  }
}