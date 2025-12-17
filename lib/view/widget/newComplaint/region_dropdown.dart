import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_form_controller.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_meta_controller.dart';
import '../../../core/constant/appcolor.dart';

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();
    final metaController = Get.find<ComplaintMetaController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Obx(() {
          if (metaController.isLoading.value) {
            return _buildLoadingState();
          }

          return DropdownButtonFormField<String>(
            value: formController.selectedRegion.value.isEmpty
                ? null
                : formController.selectedRegion.value,
            decoration: InputDecoration(
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

              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              hintText: 'select_region'.tr,
              hintStyle: const TextStyle(color: Colors.black26),
            ),
            items: metaController.regionList.map((String region) {
              return DropdownMenuItem<String>(
                value: region,
                child: Text(region),
              );
            }).toList(),
            onChanged: formController.updateRegion,
            validator: formController.validateRegion,
          );
        }),
      ],
    );
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
          Text('loading_regions'.tr),
        ],
      ),
    );
  }
}