import 'package:get/get.dart';

import '../../../../core/services/complaint/complaint_service.dart';
import '../../../../data/models/complaint/complaint_meta_model.dart';

class ComplaintMetaController extends GetxController {
  final ComplaintService _complaintService = ComplaintService();

  var categories = <ComplaintCategory>[].obs;
  var departments = <ComplaintDepartment>[].obs;
  var regions = <ComplaintRegion>[].obs;

  var complaintTypes = <String>[].obs;
  var responsibleEntities = <String>[].obs;
  var regionList = <String>[].obs;

  var isLoading = false.obs;
  var isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchComplaintMeta();
  }

  Future<void> fetchComplaintMeta() async {
    try {
      isLoading.value = true;
      print('🔄 Fetching complaint meta...');

      final complaintMeta = await _complaintService.getComplaintMeta();

      if (complaintMeta != null) {
        _updateMetaData(complaintMeta);
        print('✅ Complaint meta loaded successfully');
      }
    } catch (e) {
      print('❌ Error fetching complaint meta: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshComplaintMeta() async {
    try {
      isRefreshing.value = true;
      final complaintMeta = await _complaintService.refreshComplaintMeta();

      if (complaintMeta != null) {
        _updateMetaData(complaintMeta);
        Get.snackbar('Success'.tr, 'Data updated'.tr);
      }
    } catch (e) {
      print('❌ Error refreshing meta: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  void _updateMetaData(ComplaintMeta meta) {
    categories.value = meta.categories;
    departments.value = meta.departments;
    regions.value = meta.regions;

    complaintTypes.value = categories.map((cat) => cat.label).toList();

    responsibleEntities.value = departments.map((dept) => dept.name).toList();

    regionList.value = regions.map((region) => region.name).toList();
  }

  // Helper functions
  ComplaintCategory? getCategoryById(int id) {
    try {
      return categories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  ComplaintDepartment? getDepartmentById(int id) {
    try {
      return departments.firstWhere((dept) => dept.id == id);
    } catch (_) {
      return null;
    }
  }

  ComplaintRegion? getRegionById(int id) {
    try {
      return regions.firstWhere((region) => region.id == id);
    } catch (_) {
      return null;
    }
  }

}