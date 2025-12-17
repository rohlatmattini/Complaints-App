import 'dart:convert';
import '../../model/complaint/complaint_meta_model.dart';

class ComplaintMetaCache {
  final ComplaintMeta meta;
  final DateTime cachedAt;
  final String cacheKey;

  ComplaintMetaCache({
    required this.meta,
    required this.cachedAt,
    required this.cacheKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'cachedAt': cachedAt.toIso8601String(),
      'cacheKey': cacheKey,
    };
  }

  factory ComplaintMetaCache.fromJson(Map<String, dynamic> json) {
    return ComplaintMetaCache(
      meta: ComplaintMeta.fromJson(json['meta']),
      cachedAt: DateTime.parse(json['cachedAt']),
      cacheKey: json['cacheKey'],
    );
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  factory ComplaintMetaCache.fromJsonString(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);

      // التحقق من الحقول المطلوبة
      if (json['meta'] == null || json['cachedAt'] == null || json['cacheKey'] == null) {
        throw FormatException('Missing required fields in cache');
      }

      return ComplaintMetaCache(
        meta: ComplaintMeta.fromJson(json['meta']),
        cachedAt: DateTime.parse(json['cachedAt']),
        cacheKey: json['cacheKey'] ?? '',
      );
    } catch (e) {
      print('❌ Error parsing cache JSON: $e');
      print('❌ JSON string: $jsonString');
      throw FormatException('Invalid cache JSON: $e');
    }
  }
  // التحقق من صلاحية الكاش (مدة صلاحية 24 ساعة)
  bool get isValid {
    final now = DateTime.now();
    final diff = now.difference(cachedAt);
    return diff.inHours < 24; // صلاحية لمدة 24 ساعة
  }
}