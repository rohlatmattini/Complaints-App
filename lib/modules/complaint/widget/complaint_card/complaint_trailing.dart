
import 'package:flutter/material.dart';
import '../../../../core/constants/appcolor.dart';

class ComplaintTrailing extends StatelessWidget {
  final bool isDark;

  const ComplaintTrailing({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: isDark ? AppColor.darkSubtitle : AppColor.subtitleColor,
    );
  }
}