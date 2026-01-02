// lib/view/screen/complaint/complaint_details_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolor.dart';
import '../../../data/models/complaint/user_complaint.dart';
import '../controller/user_complaint_controller/user_complaint_controller.dart';
import '../widget/ComplaintDetails/complaint_attachments.dart';
import '../widget/ComplaintDetails/complaint_basic_info.dart';
import '../widget/ComplaintDetails/complaint_header.dart';
import '../widget/ComplaintDetails/complaint_status_badge.dart';



class ComplaintDetailsScreen extends StatelessWidget {
  final int complaintId;
  final UserComplaintController controller = Get.find();

  ComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('ComplaintDetails'.tr,textAlign:TextAlign.center),
        backgroundColor: AppColor.blue,
        foregroundColor: isDark ? AppColor.darkText : AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColor.darkText : AppColor.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<UserComplaint?>(
        future: controller.loadComplaintDetails(complaintId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColor.blue));
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColor.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'failed_to_load_details'.tr,
                    style: TextStyle(
                      color: isDark ? AppColor.darkText : AppColor.textColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blue,
                      foregroundColor: AppColor.white,
                    ),
                    child: Text('go_back'.tr),
                  ),
                ],
              ),
            );
          }

          final complaint = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                ComplaintDetailsHeader(complaint: complaint, isDark: isDark),

                const SizedBox(height: 24),

                // Basic Information
                _buildSectionTitle('basic_information'.tr, Icons.info_outline, isDark),
                const SizedBox(height: 12),
                BasicInfoWidget(complaint: complaint, isDark: isDark),

                const SizedBox(height: 24),

                // Status Only (Priority removed)
                _buildSectionTitle('status'.tr, Icons.assessment, isDark),
                const SizedBox(height: 12),
                StatusWidget(complaint: complaint, isDark: isDark),

                const SizedBox(height: 24),

                // Attachments Section
                if (complaint.attachments.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('attachments'.tr, Icons.attach_file, isDark),
                      const SizedBox(height: 12),
                      AttachmentsWidget(attachments: complaint.attachments, isDark: isDark),
                    ],
                  ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: AppColor.blue, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColor.darkText : AppColor.textColor,
          ),
        ),
      ],
    );
  }
}