
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/appcolor.dart';
import '../../../data/model/complaint/user_complaint.dart';
import 'complaint_card/complaint_status_icon.dart';
import 'complaint_card/complaint_subtitle.dart';
import 'complaint_card/complaint_title.dart';
import 'complaint_card/complaint_trailing.dart';


class ComplaintCard extends StatelessWidget {
  final UserComplaint complaint;
  final bool isDark;
  final VoidCallback onTap;

  const ComplaintCard({
    Key? key,
    required this.complaint,
    required this.isDark,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: AppColor.getCardColor(isDark: isDark),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ComplaintStatusIcon(complaint: complaint,isDark: isDark,),
        title: ComplaintTitle(complaint: complaint, isDark: isDark),
        subtitle: ComplaintSubtitle(complaint: complaint, isDark: isDark),
        trailing: ComplaintTrailing(isDark: isDark),
        onTap: onTap,
      ),
    );
  }
}