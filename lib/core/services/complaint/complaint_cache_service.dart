import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../../data/models/complaint/complaint_meta_model.dart';
import '../../localization/locale_controller.dart';

class ComplaintCacheService  {
  static const String _cacheKey = 'complaint_meta_cache_simple';
  static const String _cacheTimestampKey = 'complaint_meta_timestamp';
  final MyLocaleController langController = Get.find();


  Future<void> saveMeta(ComplaintMeta meta) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final metaJson = meta.toJson();

      final cacheData = {
        'meta': metaJson,
        'language': langController.currentLangFromPref,
        'version': 1,
      };

      final jsonString = json.encode(cacheData);

      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);

      print('✅ Complaint meta cached successfully');
      print('   - Categories: ${meta.categories.length}');
      print('   - Departments: ${meta.departments.length}');
      print('   - Regions: ${meta.regions.length}');
    } catch (e) {
      print('❌ Error saving cache: $e');
    }
  }

  Future<ComplaintMeta?> getMeta() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheString = prefs.getString(_cacheKey);
      final timestamp = prefs.getInt(_cacheTimestampKey);

      if (cacheString == null || timestamp == null) {
        print('📭 No cache found');
        return null;
      }

      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      const maxAge = 24 * 60 * 60 * 1000;

      if (cacheAge > maxAge) {
        print('⏰ Cache expired (${(cacheAge / (60 * 60 * 1000)).toStringAsFixed(1)} hours)');
        await clear();
        return null;
      }

      final cacheData = json.decode(cacheString) as Map<String, dynamic>;

      final cachedLanguage = cacheData['language'] as String?;
      final currentLanguage = langController.currentLangFromPref;

      if (cachedLanguage != currentLanguage) {
        print('🌐 Language changed ($cachedLanguage → $currentLanguage)');
        await clear();
        return null;
      }

      final version = cacheData['version'] as int? ?? 0;
      if (version != 1) {
        print('🔄 Cache version mismatch');
        await clear();
        return null;
      }

      final metaJson = cacheData['meta'] as Map<String, dynamic>;
      final meta = ComplaintMeta.fromJson(metaJson);

      print('✅ Using cached complaint meta');
      print('   - Categories: ${meta.categories.length}');
      print('   - Departments: ${meta.departments.length}');
      print('   - Regions: ${meta.regions.length}');
      print('   - Cache age: ${(cacheAge / (60 * 60 * 1000)).toStringAsFixed(1)} hours');

      return meta;
    } catch (e) {
      print('❌ Error reading cache: $e');
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimestampKey);
      print('🗑️ Complaint cache cleared');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }

  Future<bool> hasValidCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cacheKey) && prefs.containsKey(_cacheTimestampKey);
    } catch (e) {
      return false;
    }
  }
}