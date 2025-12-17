import 'package:complaints/core/constant/appcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  MainButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: AppColor.white,size: 40.sp),
        label: Text(label, style:  TextStyle(fontSize: 22.sp,color: AppColor.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor:  AppColor.blue,
          padding:  EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),

          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
