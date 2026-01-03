import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolor.dart';

class RememberForgotRow extends StatelessWidget {
  final bool rememberPassword;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback? onForgotTap;

  const RememberForgotRow({
    super.key,
    required this.rememberPassword,
    required this.onRememberChanged,
    this.onForgotTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberPassword,
              onChanged: onRememberChanged,
              activeColor: isDark?AppColor.white: AppColor.blue,
            ),
             Text(
              'Remember me'.tr,
              style: TextStyle(color: isDark?AppColor.white:Colors.black45),
            ),
          ],
        ),
        GestureDetector(
          onTap: onForgotTap,
          child: Text(
            'Forget password?'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : AppColor.blue,
            ),
          ),
        ),
      ],
    );
  }
}
