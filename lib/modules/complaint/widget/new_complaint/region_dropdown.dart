import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/appcolor.dart';
import '../../controller/new_complaint_controller/complaint_form_controller.dart';
import '../../controller/new_complaint_controller/complaint_meta_controller.dart';

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();
    final metaController = Get.find<ComplaintMetaController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Obx(() {
          if (metaController.isLoading.value) {
            return _buildLoadingState(isDark: isDark);
          }

          return DropdownButtonFormField<String>(
            value: formController.selectedRegion.value.isEmpty
                ? null
                : formController.selectedRegion.value,
            items: metaController.regionList.map((String region) {
              return DropdownMenuItem<String>(
                value: region,
                child: Text(
                  region,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: formController.updateRegion,
            validator: formController.validateRegion,
            decoration: InputDecoration(
              hintText: 'select_region'.tr,
              hintStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.black38,
              ),
              filled: true,
              fillColor: isDark ? AppColor.getCardColor(isDark: true) : Colors.white,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
          );
        }),
      ],
    );
  }

  Widget _buildLoadingState({required bool isDark}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColor.getCardColor(isDark: true) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white38 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            color: isDark ? Colors.white : AppColor.blue,
          ),
          SizedBox(width: 12.w),
          Text(
            'loading_regions'.tr,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
