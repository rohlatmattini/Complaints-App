import 'attachment_model.dart';
import 'complaint_meta_model.dart';

class UserComplaint {
  final int id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final ComplaintCategory category;
  final ComplaintDepartment department;
  final Region? region;
  final List<Attachment> attachments;
  final List<Version> versions;
  final int createdBy;
  final String? referenceNumber;
  final int rowVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserComplaint({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    required this.department,
    this.region,
    required this.attachments,
    required this.versions,
    required this.createdBy,
    this.referenceNumber,
    required this.rowVersion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserComplaint.fromJson(Map<String, dynamic> json) {
    return UserComplaint(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      category: ComplaintCategory.fromJson(json['category']),
      department: ComplaintDepartment.fromJson(json['department']),
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      attachments: (json['attachments'] as List? ?? [])
          .map((item) => Attachment.fromJson(item))
          .toList(),
      versions: (json['versions'] as List? ?? [])
          .map((item) => Version.fromJson(item))
          .toList(),
      createdBy: json['created_by'],
      referenceNumber: json['reference_number'],
      rowVersion: json['row_version'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }


}

class Version {
  final int id;
  final int versionNumber;
  final String title;
  final String description;
  final String status;
  final String priority;
  final int categoryId;
  final int departmentId;
  final int? regionId;
  final int changedBy;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  Version({
    required this.id,
    required this.versionNumber,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.categoryId,
    required this.departmentId,
    this.regionId,
    required this.changedBy,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      id: json['id'],
      versionNumber: json['version_number'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      categoryId: json['category_id'],
      departmentId: json['department_id'],
      regionId: json['region_id'],
      changedBy: json['changed_by'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Region {
  final int id;
  final String name;

  Region({
    required this.id,
    required this.name,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class UserComplaintResponse {
  final List<UserComplaint> complaints;
  final int currentPage;
  final int lastPage;
  final int total;

  UserComplaintResponse({
    required this.complaints,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory UserComplaintResponse.fromJson(Map<String, dynamic> json) {
    return UserComplaintResponse(
      complaints: (json['data'] as List)
          .map((item) => UserComplaint.fromJson(item))
          .toList(),
      currentPage: json['meta']['current_page'],
      lastPage: json['meta']['last_page'],
      total: json['meta']['total'],
    );
  }
}

extension UserComplaintCopy on UserComplaint {
  UserComplaint copyWith({
    String? status,
  }) {
    return UserComplaint(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
      priority: priority,
      category: category,
      department: department,
      region: region,
      attachments: attachments,
      versions: versions,
      createdBy: createdBy,
      referenceNumber: referenceNumber,
      rowVersion: rowVersion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

