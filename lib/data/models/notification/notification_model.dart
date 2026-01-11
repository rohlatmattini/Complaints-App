import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../modules/complaint/controller/user_complaint_controller/user_complaint_controller.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? 'إشعار',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['read_at'] != null,
    );
  }

  int? get complaintId {
    if (type.contains('complaint') && data != null) {
      final complaintId = data!['complaint_id'];
      if (complaintId != null) {
        return int.tryParse(complaintId.toString());
      }
    }
    return null;
  }

  String getComplaintTitle() {
    final complaintId = this.complaintId;
    if (complaintId == null) return '';

    try {
      if (Get.isRegistered<UserComplaintController>()) {
        final userComplaintController = Get.find<UserComplaintController>();
        final complaint = userComplaintController.complaints
            .firstWhereOrNull((c) => c.id == complaintId);
        return complaint?.title ?? 'شكوى #$complaintId';
      }
    } catch (e) {
      print('خطأ في الحصول على اسم الشكوى: $e');
    }
    return 'شكوى #$complaintId';
  }

  String getComplaintCategory() {
    final complaintId = this.complaintId;
    if (complaintId == null) return '';

    try {
      if (Get.isRegistered<UserComplaintController>()) {
        final userComplaintController = Get.find<UserComplaintController>();
        final complaint = userComplaintController.complaints
            .firstWhereOrNull((c) => c.id == complaintId);
        return complaint?.category.label ?? '';
      }
    } catch (e) {
      print('خطأ في الحصول على الفئة: $e');
    }
    return '';
  }

  String getComplaintDepartment() {
    final complaintId = this.complaintId;
    if (complaintId == null) return '';

    try {
      if (Get.isRegistered<UserComplaintController>()) {
        final userComplaintController = Get.find<UserComplaintController>();
        final complaint = userComplaintController.complaints
            .firstWhereOrNull((c) => c.id == complaintId);
        return complaint?.department.name ?? '';
      }
    } catch (e) {
      print('خطأ في الحصول على القسم: $e');
    }
    return '';
  }

  Map<String, String> getComplaintInfo() {
    return {
      'title': getComplaintTitle(),
      'category': getComplaintCategory(),
      'department': getComplaintDepartment(),
    };
  }

  String getCleanBody() {
    String bodyText = body.toString();
    RegExp pattern = RegExp(r'Your complaint CMP-\d{4}-\d{6}');
    String cleanedBody = bodyText.replaceAll(pattern, '').trim();
    cleanedBody = cleanedBody.replaceFirst('Your complaint', '').trim();
    cleanedBody = cleanedBody.trim();

    if (Get.locale?.languageCode == 'ar') {
      cleanedBody = _translateToArabic(cleanedBody);
    } else {
      cleanedBody = _translateToEnglish(cleanedBody);
    }

    return cleanedBody.isNotEmpty ? cleanedBody : bodyText;
  }

  String _translateToArabic(String text) {
    String translated = text
        .replaceAll('status has been updated to', 'تم تحديث حالة الشكوى إلى')
        .replaceAll('Pending', 'قيد المراجعة')
        .replaceAll('pending', 'قيد المراجعة')
        .replaceAll('Rejected', 'مرفوضة')
      .replaceAll('rejected', 'مرفوضة')
        .replaceAll('open', 'مفتوحة')
        .replaceAll('resolved', 'تم الحل')
        .replaceAll('Resolved', 'تم الحل')
        .replaceAll('In progress', 'تحت المعالجة')
        .replaceAll('in_progress', 'تحت المعالجة')
        .replaceAll('Accepted', 'مقبولة')
        .replaceAll('accepted', 'مقبولة')
        .replaceAll('Under Review', 'قيد المراجعة')
        .replaceAll('under Review', 'قيد المراجعة')
        .replaceAll('Open', 'مفتوحة')
        .replaceAll('Needs More Info', 'تحتاج لمزيد من المعلومات')
        .replaceAll('needs_more_info', 'تحتاج لمزيد من المعلومات')
        .replaceAll('needs more info', 'تحتاج لمزيد من المعلومات')
        .replaceAll('closed', 'مغلقة')
        .replaceAll('Closed', 'مغلقة')
        .replaceAll('More information required', 'معلومات إضافية مطلوبة')
        .replaceAll(
        'More information has been requested for your', 'تم طلب معلومات إضافية من أجل ')
        .replaceAll('complaint', 'شكوى رقم')
        .replaceAll('has been assigned', 'تم تعيينها')
        .replaceAll('A new reply has been added', 'تمت إضافة رد جديد')
        .replaceAll('New message received', 'تم استلام رسالة جديدة')
        .replaceAll('System notification', 'إشعار نظام');

  if (translated.startsWith('تم تحديث حالة الشكوى إلى')) {
      translated = '$translated';
    }
    return translated;
  }

  String _translateToEnglish(String text) {
    return text;
  }

  String getDisplayBody() {
    if (type.contains('complaint') &&
        (body.contains('Your complaint') || body.contains('status has been updated')||
            body.contains('More information'))) {

      return getCleanBody();
    }
    return body;
  }

  String get displayBody => getDisplayBody();

  String get displayTitle {
    if (Get.locale?.languageCode == 'ar') {
      return _translateTitleToArabic(title);
    }
    return title;
  }

  String _translateTitleToArabic(String title) {
    String arabicTitle = title
        .replaceAll("Complaint status updated", "تم تحديث حالة الشكوى")
    .replaceAll("More information required", "معلومات إضافية مطلوبة");

    return arabicTitle;
  }

  String getFullNotificationText() {
    StringBuffer fullText = StringBuffer();

    fullText.writeln(displayTitle);
    fullText.writeln();

    if (complaintId != null) {
      fullText.writeln('اسم الشكوى: ${getComplaintTitle()}');

      final category = getComplaintCategory();
      final department = getComplaintDepartment();

      if (category.isNotEmpty || department.isNotEmpty) {
        fullText.writeln('الفئة/القسم: $category - $department');
      }
      fullText.writeln();
    }

    fullText.writeln(displayBody);

    return fullText.toString();
  }

  String getNotificationSummary() {
    String summary = '';

    if (complaintId != null) {
      summary = '${getComplaintTitle()}: ${displayBody}';
    } else {
      summary = displayBody;
    }

    return summary;
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'قبل ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'قبل ${difference.inHours} ساعة';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  String get icon {
    switch (type) {
      case 'complaint_update':
      case 'complaint_status_changed':
        return 'assets/icons/complaint_notification.png';
      case 'new_message':
        return 'assets/icons/message_notification.png';
      case 'system':
        return 'assets/icons/system_notification.png';
      default:
        return 'assets/icons/notification.png';
    }
  }
}