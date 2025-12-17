// lib/view/widget/complaint/complaint_title.dart

import 'package:flutter/material.dart';

import '../../../../core/constant/appcolor.dart';
import '../../../../data/model/complaint/user_complaint.dart';

class ComplaintTitle extends StatelessWidget {
  final UserComplaint complaint;
  final bool isDark;

  const ComplaintTitle({
    Key? key,
    required this.complaint,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      complaint.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: isDark ? AppColor.darkText : AppColor.textColor,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}