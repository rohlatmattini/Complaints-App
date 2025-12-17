import 'complaint_model.dart';

class ComplaintCategory {
  final int id;
  final String label;
  final String description;
  final bool isActive;

  ComplaintCategory({
    required this.id,
    required this.label,
    required this.description,
    required this.isActive,
  });

  factory ComplaintCategory.fromJson(Map<String, dynamic> json) {
    return ComplaintCategory(
      id: json['id'] as int,
      label: json['label'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'is_active': isActive ? 1 : 0,
    };
  }
}

class ComplaintDepartment {
  final int id;
  final String name;
  final String description;
  final bool isActive;

  ComplaintDepartment({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory ComplaintDepartment.fromJson(Map<String, dynamic> json) {
    return ComplaintDepartment(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive ? 1 : 0,
    };
  }
}

class ComplaintRegion {
  final int id;
  final String name;
  // ملاحظة: الـ JSON لا يحتوي على is_active أو code
  // ولكن قد يكونان null في بعض الحالات

  ComplaintRegion({
    required this.id,
    required this.name,
  });

  factory ComplaintRegion.fromJson(Map<String, dynamic> json) {
    return ComplaintRegion(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // لا نضيف حقول غير موجودة في الـ JSON الأصلي
    };
  }
}

class ComplaintMeta {
  final List<ComplaintCategory> categories;
  final List<ComplaintDepartment> departments;
  final List<ComplaintRegion> regions;

  ComplaintMeta({
    required this.categories,
    required this.departments,
    required this.regions,
  });

  factory ComplaintMeta.fromJson(Map<String, dynamic> json) {
    try {
      return ComplaintMeta(
        categories: (json['categories'] as List)
            .map((item) => ComplaintCategory.fromJson(item))
            .toList(),
        departments: (json['departments'] as List)
            .map((item) => ComplaintDepartment.fromJson(item))
            .toList(),
        regions: (json['regions'] as List)
            .map((item) => ComplaintRegion.fromJson(item))
            .toList(),
      );
    } catch (e) {
      print('❌ Error parsing ComplaintMeta: $e');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((cat) => cat.toJson()).toList(),
      'departments': departments.map((dept) => dept.toJson()).toList(),
      'regions': regions.map((region) => region.toJson()).toList(),
    };
  }
}