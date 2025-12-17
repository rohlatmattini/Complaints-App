// lib/view/widget/complaint/complaint_details/basic_info_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/appcolor.dart';
import '../../../../data/model/complaint/user_complaint.dart';

class BasicInfoWidget extends StatelessWidget {
  final UserComplaint complaint;
  final bool isDark;

  const BasicInfoWidget({
    Key? key,
    required this.complaint,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColor.getCardColor(isDark: isDark),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              label: 'category'.tr,
              value: complaint.category.label,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'department'.tr,
              value: complaint.department.name,
            ),
            if (complaint.region != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                label: 'region'.tr,
                value: complaint.region!.name,
              ),
            ],
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'created_date'.tr,
              value: _formatDateTime(complaint.createdAt),
            ),
            if (complaint.updatedAt != complaint.createdAt) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                label: 'updated_date'.tr,
                value: _formatDateTime(complaint.updatedAt),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColor.darkText : AppColor.textColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColor.darkSubtitle : AppColor.subtitleColor,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}