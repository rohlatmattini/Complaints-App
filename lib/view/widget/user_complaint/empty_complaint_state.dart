// lib/view/widget/complaint/empty_complaints_state.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/appcolor.dart';

class EmptyComplaintsState extends StatelessWidget {
  final bool isDark;
  final VoidCallback onCreateComplaint;

  const EmptyComplaintsState({
    Key? key,
    required this.isDark,
    required this.onCreateComplaint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          const SizedBox(height: 16),
          _buildTitle(),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          _buildCreateButton(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      Icons.inbox_outlined,
      size: 80,
      color: isDark ? AppColor.darkGrey : AppColor.mediumGrey,
    );
  }

  Widget _buildTitle() {
    return Text(
      'no_complaints_found'.tr,
      style: TextStyle(
        fontSize: 18,
        color: isDark ? AppColor.darkSubtitle : AppColor.subtitleColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }



  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: onCreateComplaint,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.blue,
        foregroundColor: AppColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text('create_first_complaint'.tr),
    );
  }
}