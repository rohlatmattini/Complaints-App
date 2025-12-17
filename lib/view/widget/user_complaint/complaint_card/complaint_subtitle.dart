// lib/view/widget/complaint/complaint_subtitle.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/appcolor.dart';
import '../../../../data/model/complaint/user_complaint.dart';

class ComplaintSubtitle extends StatelessWidget {
  final UserComplaint complaint;
  final bool isDark;

  const ComplaintSubtitle({
    Key? key,
    required this.complaint,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final statusColor = AppColor.getStatusColor(complaint.status, isDark: isDark);
    final priorityColor = AppColor.getPriorityColor(complaint.priority, isDark: isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        // الوصف
        Text(
          complaint.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDark ? AppColor.darkSubtitle : AppColor.subtitleColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Status Chip
            Chip(
              label: Text(
                complaint.status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: statusColor.withOpacity(0.1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            // Priority Chip

          ],
        ),
        const SizedBox(height: 4),
        // الفئة
        Text(
          '${'category'.tr}: ${complaint.category.label}',
          style: TextStyle(
            color: isDark ? AppColor.darkSubtitle : AppColor.bluegrey,
            fontSize: 12,
          ),
        ),
        // التاريخ
        Text(
          '${'date'.tr}: ${_formatDate(complaint.createdAt)}',
          style: TextStyle(
            color: isDark ? AppColor.darkSubtitle : AppColor.bluegrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}