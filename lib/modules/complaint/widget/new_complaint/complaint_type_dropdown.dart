import 'package:complaints/core/constants/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/new_complaint_controller/complaint_form_controller.dart';
import '../../controller/new_complaint_controller/complaint_meta_controller.dart';

class ComplaintTypeDropdown extends StatelessWidget {
  const ComplaintTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();
    final metaController = Get.find<ComplaintMetaController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (metaController.isLoading.value) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColor.getCardColor(isDark: true) : Colors.white,
            border: Border.all(
              color: isDark ? Colors.white38 : AppColor.grey,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.cached,
                color: isDark ? Colors.white : AppColor.blue,
              ),
              SizedBox(width: 8.w),
              Text(
                'Loading from cache...'.tr,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
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
            child: Text(
              value.tr,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          );
        }).toList(),
        onChanged: formController.updateComplaintType,
        decoration: InputDecoration(
          hintText: 'Complaint Type'.tr,
          hintStyle: TextStyle(
            color: isDark ? Colors.white70 : AppColor.blue,
          ),
          filled: true,
          fillColor: isDark ? AppColor.getCardColor(isDark: true) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isDark ? Colors.white : AppColor.blue,
              width: 2,
            ),
          ),
        ),
        dropdownColor: isDark ? AppColor.getCardColor(isDark: true) : Colors.white,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
        ),
        validator: formController.validateComplaintType,
      );
    });
  }
}
