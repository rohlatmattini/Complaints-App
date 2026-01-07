
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/appcolor.dart';
import '../../../core/utils/load_indicator.dart';
import '../../../data/models/drawer/main_drawer.dart';
import '../controller/new_complaint_controller/complaint_form_controller.dart';
import '../controller/user_complaint_controller/user_complaint_controller.dart';
import '../widget/user_complaint/complaint_card.dart';
import '../widget/user_complaint/complaint_filter_menu.dart';
import '../widget/user_complaint/empty_complaint_state.dart';
import '../widget/user_complaint/search_complaint_bar.dart';
import 'complaint_details_screen..dart';

class UserComplaintsScreen extends StatelessWidget {
  final UserComplaintController controller = Get.find();

  UserComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'my_complaints'.tr,
          style: TextStyle(
            color: isDark ? AppColor.darkText : AppColor.white,
          ),
        ),
        backgroundColor: isDark?AppColor.darkBlueGrey:AppColor.blue,
        foregroundColor: isDark ? AppColor.darkText : AppColor.white,
        actions: [
          ComplaintFilterMenu(
            controller: controller,
            isDark: isDark,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchComplaintBar(
            onSearchChanged: (value) => controller.searchQuery.value = value,
            isDark: isDark,
          ),

          // Complaints List
          Expanded(
            child: RefreshIndicator(
              color: AppColor.blue,
              onRefresh: () => controller.refreshComplaints(),
              child: Obx(() => _buildComplaintsList(isDark)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // نتحقق إذا كان الكنترول موجوداً، نقوم بتصفيره، وإلا نقوم بإنشائه
          if (Get.isRegistered<ComplaintFormController>()) {
            Get.find<ComplaintFormController>().clearForm();
          } else {
            Get.put(ComplaintFormController()).clearForm();
          }
          Get.toNamed(AppRoute.addNewComplaint);
        },
        backgroundColor: AppColor.blue,
        child: Icon(Icons.add, color: AppColor.white),
      ),
    );
  }

  Widget _buildComplaintsList(bool isDark) {
    if (controller.isRefreshing.value && controller.complaints.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      );
    }

    if (controller.filteredComplaints.isEmpty) {
      return EmptyComplaintsState(
        isDark: isDark,
        onCreateComplaint: () => Get.toNamed(AppRoute.addNewComplaint),
      );
    }

    return ListView.builder(
      itemCount: controller.filteredComplaints.length + (controller.hasMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.filteredComplaints.length) {
          return LoadMoreIndicator(
            isLoading: controller.isLoading.value,
          );
        }

        final complaint = controller.filteredComplaints[index];
        return ComplaintCard(
          complaint: complaint,
          isDark: isDark,
          onTap: () => _navigateToComplaintDetails(complaint.id),
        );
      },
    );
  }

  void _navigateToComplaintDetails(int complaintId) {
    Get.toNamed(
      AppRoute.complaintDetails,
      arguments: complaintId,
    );
  }



}