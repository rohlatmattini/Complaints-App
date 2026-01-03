import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants/appcolor.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final void Function(String)? onChanged;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      cursorColor: AppColor.blue,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        // ✅ لون الـ label
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),

        // ✅ لون الـ hint
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : Colors.black26,
        ),


        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: isDark?AppColor.white: AppColor.blue,
        )
            : null,

        suffixIcon: suffixIcon != null
            ? IconButton(
          onPressed: onSuffixPressed,
          icon: Icon(
            suffixIcon,
            color: isDark?AppColor.white: AppColor.blue,
          ),
        )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white38 : Colors.black12,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white38 : Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: isDark?AppColor.white: AppColor.blue,
            width: 1.8,
          ),
        ),
      ),
    );
  }

}