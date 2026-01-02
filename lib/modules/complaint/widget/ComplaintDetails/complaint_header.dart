// lib/view/widget/complaint/complaint_details/header_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/appcolor.dart';
import '../../../../data/models/complaint/user_complaint.dart';

class ComplaintDetailsHeader extends StatelessWidget {
  final UserComplaint complaint;
  final bool isDark;

  const ComplaintDetailsHeader({
    Key? key,
    required this.complaint,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: MediaQuery.of(context).size.width, // عرض الشاشة بالكامل
      child: Card(
        elevation: 2,
        color: AppColor.getCardColor(isDark: isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                complaint.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColor.darkText : AppColor.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                complaint.description,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColor.darkSubtitle : AppColor.subtitleColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
