//
class ComplaintModel {
  String? id;
  String title;
  String description;
  String? status;
  String? priority;
  String complaintType;
  String responsibleEntity;
  String location;
  String? region;
  int? regionId;
  List<String> attachedFiles;
  String referenceNumber;
  DateTime createdAt;

  ComplaintModel({
    this.id,
    required this.title,
    required this.description,
    this.status,
    this.priority,
    required this.complaintType,
    required this.responsibleEntity,
    required this.location,
    this.region,
    this.regionId,
    this.attachedFiles = const [],
    required this.referenceNumber,
    required this.createdAt,
  });

  ComplaintModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? complaintType,
    String? responsibleEntity,
    String? location,
    String? region,
    int? regionId,
    List<String>? attachedFiles,
    String? referenceNumber,
    DateTime? createdAt,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      complaintType: complaintType ?? this.complaintType,
      responsibleEntity: responsibleEntity ?? this.responsibleEntity,
      location: location ?? this.location,
      region: region ?? this.region,
      regionId: regionId ?? this.regionId,
      attachedFiles: attachedFiles ?? this.attachedFiles,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'complaintType': complaintType,
      'responsibleEntity': responsibleEntity,
      'location': location,
      'region': region,
      'regionId': regionId,
      'attachedFiles': attachedFiles,
      'referenceNumber': referenceNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'],
      priority: json['priority'],
      complaintType: json['category'] != null ? json['category']['label'] ?? '' : '',
      responsibleEntity: json['department'] != null ? json['department']['name'] ?? '' : '',
      location: json['location'] ?? '',
      region: json['region'] != null ? json['region']['name'] ?? '' : '',
      regionId: json['region_id'] ?? json['region']?['id'],
      attachedFiles: List<String>.from(json['attachedFiles'] ?? []),
      referenceNumber: json['referenceNumber'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
