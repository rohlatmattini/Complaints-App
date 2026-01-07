
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/appcolor.dart';
import '../../../../data/models/complaint/user_complaint.dart';
import '../../controller/new_complaint_controller/complaint_form_controller.dart';
import '../../controller/user_complaint_controller/user_complaint_controller.dart';

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
    final cleanStatus = ComplaintTextHelper.normalizeStatus(complaint.status).tr;
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
          cleanStatus.tr,
     style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: statusColor.withOpacity(0.1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
            ),
            if (cleanStatus == 'needs_more_info'.tr)
              TextButton.icon(
                onPressed: () {
                  final formController = Get.put(ComplaintFormController());
                  formController.loadComplaintToEdit(complaint);
                  Get.toNamed(AppRoute.addNewComplaint);
                },
                icon: const Icon(Icons.edit, size: 16, color: AppColor.blue),
                label: Text('edit'.tr, style: const TextStyle(color: AppColor.blue)),
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