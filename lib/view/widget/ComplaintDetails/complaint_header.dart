// lib/view/widget/complaint/complaint_details/header_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/appcolor.dart';
import '../../../../data/model/complaint/user_complaint.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      width:MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        color: AppColor.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            complaint.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColor.darkText : AppColor.textColor,
            ),
          ),
          const SizedBox(height: 8),
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
    );
  }
}