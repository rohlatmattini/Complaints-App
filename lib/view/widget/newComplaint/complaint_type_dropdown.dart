import 'package:complaints/core/constant/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_form_controller.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_meta_controller.dart';

class ComplaintTypeDropdown extends StatelessWidget {
  const ComplaintTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();
    final metaController = Get.find<ComplaintMetaController>();

    return Obx(() {
      if (metaController.isLoading.value) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.cached, color: AppColor.blue),
              SizedBox(width: 8),
              Text('Loading from cache...'.tr),
            ],
          ),
        );
      }

      return DropdownButtonFormField<String>(
        value: formController.complaint.value.complaintType.isEmpty
            ? null
            : formController.complaint.value.complaintType,
        items: metaController.complaintTypes.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.tr),
          );
        }).toList(),
        onChanged: formController.updateComplaintType,
        decoration: InputDecoration(
          hintText: 'Complaint Type'.tr,
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
        validator: formController.validateComplaintType,
      );
    });
  }
}