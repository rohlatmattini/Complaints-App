import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/appcolor.dart';

class MessageField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int? maxLines;
  final String? Function(String?)? validator;

  const MessageField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 5,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: isDark ? AppColor.white : AppColor.blue,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? Colors.white30 : Colors.grey[400]!,
              width: 1.5,
            ),
            color: isDark ? AppColor.darkSurface.withOpacity(0.5) : Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            minLines: 5,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? AppColor.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint.tr,
              hintStyle: TextStyle(
                color: isDark ? Colors.white60 : Colors.grey[600],
                fontSize: 13.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
            ),
            validator: validator,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Please provide all requested information clearly'.tr,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey[600],
            fontSize: 11.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}