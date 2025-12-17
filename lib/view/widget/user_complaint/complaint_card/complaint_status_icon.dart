// lib/view/widget/complaint/complaint_status_icon.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constant/appcolor.dart';
import '../../../../data/model/complaint/user_complaint.dart';

class ComplaintStatusIcon extends StatelessWidget {
  final UserComplaint complaint;
  final bool isDark;
  const ComplaintStatusIcon({Key? key, required this.complaint,    required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColor.getStatusColor(complaint.status, isDark: isDark);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Icon(
        _getStatusIcon(complaint.status),
        color: statusColor,
        size: 24,
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.tr) {
      case 'قيد المراجعة':
        return Icons.hourglass_empty;
      case 'مقبولة':
        return Icons.check_circle;
      case 'مرفوضة':
        return Icons.cancel;
      case 'مكتملة':
        return Icons.verified;
      default:
        return Icons.info;
    }
  }
}