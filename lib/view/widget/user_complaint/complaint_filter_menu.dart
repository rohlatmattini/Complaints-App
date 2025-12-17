// lib/view/widget/complaint/complaint_filter_menu.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/complaint/user_complaint_controller/user_complaint_controller.dart';
import '../../../core/constant/appcolor.dart';

class ComplaintFilterMenu extends StatelessWidget {
  final UserComplaintController controller;
  final bool isDark;

  const ComplaintFilterMenu({
    Key? key,
    required this.controller,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.filter_list,
        color: isDark ? AppColor.darkText : AppColor.white,
      ),
      onSelected: (value) => _handleFilterSelection(value),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildFilterMenuItem('pending', 'pending'.tr),
        _buildFilterMenuItem('open', 'open'.tr),
        _buildFilterMenuItem('resolved', 'resolved'.tr),
        _buildFilterMenuItem('closed', 'closed'.tr),
        _buildFilterMenuItem('in progress', 'in progress'.tr),
        _buildFilterMenuItem('rejected', 'rejected'.tr),

        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'clear',
          child: Row(
            children: [
              Icon(Icons.clear, color: AppColor.red),
              const SizedBox(width: 8),
              Text('clear'.tr),
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildFilterMenuItem(String? value, String text) {
    return PopupMenuItem<String>(
      value: value ?? 'all',
      child: Row(
        children: [
          if (controller.statusFilter.value == value)
            Icon(Icons.check, color: AppColor.primaryColor, size: 18)
          else
            const SizedBox(width: 18, height: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _handleFilterSelection(String value) {
    if (value == 'clear') {
      controller.clearFilters();
    } else if (value == 'all') {
      controller.statusFilter.value = null;
    } else {
      controller.statusFilter.value = value;
    }
  }
}