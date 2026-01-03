// lib/view/widget/complaint/search_complaint_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/appcolor.dart';

class SearchComplaintBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final bool isDark;

  const SearchComplaintBar({
    Key? key,
    required this.onSearchChanged,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        cursorColor: isDark ? Colors.white : AppColor.blue,
        decoration: InputDecoration(
          hintText: 'search_complaint'.tr,
          prefixIcon: Icon(Icons.search, color: AppColor.subtitleColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.getBorderColor(isDark: isDark)

            ),

          ),

          filled: true,
          fillColor:  isDark ? AppColor.getCardColor(isDark: true)  // <-- هنا
            : Colors.grey[200],
          hintStyle: TextStyle(color: AppColor.subtitleColor),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.r),
    borderSide: BorderSide(
    color: isDark ? Colors.white : AppColor.blue,
    width: 1.8,
    ),
    ),
        ),
        style: TextStyle(
          color: isDark ? AppColor.darkText : AppColor.textColor,
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}