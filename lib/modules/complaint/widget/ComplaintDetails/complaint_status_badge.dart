// lib/view/widget/complaint/complaint_details/status_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/appcolor.dart';
import '../../../../data/models/complaint/user_complaint.dart';

class StatusWidget extends StatelessWidget {
  final UserComplaint complaint;
  final bool isDark;

  const StatusWidget({
    Key? key,
    required this.complaint,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColor.getStatusColor(complaint.status, isDark: isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'status'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColor.darkSubtitle : AppColor.subtitleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getTranslatedStatus(complaint.status),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getTranslatedStatus(String status) {
    final statusLower = status.toLowerCase().trim();

    if (statusLower.contains('pending') || statusLower.contains('مراجعة')) {
      return 'pending'.tr;
    } else if (statusLower.contains('accepted') || statusLower.contains('مقبول')) {
      return 'accepted'.tr;
    } else if (statusLower.contains('rejected') || statusLower.contains('مرفوض')) {
      return 'rejected'.tr;
    } else if (statusLower.contains('completed') || statusLower.contains('مكتمل')) {
      return 'completed'.tr;
    }

    return status;
  }
}