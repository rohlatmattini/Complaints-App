// lib/core/constant/appcolor.dart

import 'package:flutter/material.dart';

class AppColor {
  // 🌞 Light Theme Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4A44B5);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF2D3748);
  static const Color subtitleColor = Color(0xFF718096);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color blue = Color(0xFF0D79C7);
  static const Color lighterBlue = Color(0xFF3D94D6);
  static const Color grey = Color(0xFFE2E8F0);
  static const Color lightGrey = Color(0xFFF7FAFC);
  static const Color mediumGrey = Color(0xFFCBD5E0);
  static const Color darkGrey = Color(0xFF4A5568);
  static const Color bluegrey = Color(0xFF758FAF);
  static const Color headerBlue = Color(0xFF0D3B66);
  static const Color red = Color(0xFFF60B2E);
  static const Color green = Color(0xFF48BB78);
  static const Color orange = Color(0xFFED8936);
  static const Color yellow = Color(0xFFECC94B);

  // 🌙 Dark Theme Colors
  static const Color darkPrimary = Color(0xFF8C82FF);
  static const Color darkSecondary = Color(0xFF635BBD);
  static const Color darkBackground = Color(0xFF2C2C3E);
  static const Color darkSurface = Color(0xFF33334A);
  static const Color darkText = Color(0xFFEDEDED);
  static const Color darkSubtitle = Color(0xFFB5B5B5);
  // static const Color darkGrey = Color(0xFF3A3A50);
  static const Color darkMediumGrey = Color(0xFF4A4A65);
  static const Color darkBlueGrey = Color(0xFF505974);
  static const Color darkRed = Color(0xFFFF5C5C);
  static const Color darkGreen = Color(0xFF68D391);
  static const Color darkOrange = Color(0xFFF6AD55);
  static const Color darkYellow = Color(0xFFF6E05E);
  static const Color darkHeaderBlue = Color(0xFF3D4A7A);

  // Status Colors
  static Color getStatusColor(String status, {bool isDark = false}) {
    final statusLower = status.toLowerCase().trim();

    // التعامل مع النصوص العربية والإنجليزية
    if (statusLower.contains('تحت المعالجة') || statusLower.contains('in progress')) {
      return isDark ? darkOrange : orange;
    } else if (statusLower.contains('مفتوحة') || statusLower.contains('open')) {
      return isDark ? darkBlueGrey : blue;
    } else if (statusLower.contains('مرفوض') || statusLower.contains('reject')) {
      return isDark ? darkRed : red;
    } else if (statusLower.contains('تم الحل') || statusLower.contains('resolved')) {
      return isDark ? darkGreen : green;
    } else if (statusLower.contains('قيد المراجعة') || statusLower.contains('pending')) {
      return isDark ? darkOrange : orange;
    }
    else if (statusLower.contains('مغلقة') || statusLower.contains('closed')) {
      return isDark ? darkOrange : orange;
    }

    return isDark ? darkGrey : grey;
  }

  static Color getPriorityColor(String priority, {bool isDark = false}) {
    final priorityLower = priority.toLowerCase().trim();

    // التعامل مع النصوص العربية والإنجليزية
    if (priorityLower.contains('عالية') || priorityLower.contains('high')) {
      return isDark ? darkRed : red;
    } else if (priorityLower.contains('متوسطة') || priorityLower.contains('medium')) {
      return isDark ? darkOrange : orange;
    } else if (priorityLower.contains('منخفضة') || priorityLower.contains('low')) {
      return isDark ? darkGreen : green;
    }

    return isDark ? darkGrey : grey;
  }

  // طريقة أفضل: استخدام القيم المعرفة من الـ API
  static Color getStatusColorByKey(String statusKey, {bool isDark = false}) {
    switch (statusKey) {
      case 'pending':
        return isDark ? darkOrange : orange;
      case 'open':
        return isDark ? darkBlueGrey : blue;
      case 'rejected':
        return isDark ? darkRed : red;
      case 'resolved':
        return isDark ? darkGreen : green;
      case 'in_progress':
        return isDark ? darkBlueGrey : blue;
      case 'closed':
        return isDark ? darkBlueGrey : blue;
      default:
        return getStatusColor(statusKey, isDark: isDark);
    }
  }







static Color getPriorityColorByKey(String priorityKey, {bool isDark = false}) {
    switch (priorityKey) {
      case 'high':
        return isDark ? darkRed : red;
      case 'medium':
        return isDark ? darkOrange : orange;
      case 'low':
        return isDark ? darkGreen : green;
      default:
        return getPriorityColor(priorityKey, isDark: isDark);
    }
  }
  // Card and Container Colors
  static Color getCardColor({bool isDark = false}) {
    return isDark ? darkSurface : surfaceColor;
  }

  static Color getSearchBarColor({bool isDark = false}) {
    return isDark ? darkGrey : lightGrey;
  }

  static Color getBorderColor({bool isDark = false}) {
    return isDark ? darkMediumGrey : mediumGrey;
  }
}