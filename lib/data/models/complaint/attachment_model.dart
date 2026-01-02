class Attachment {
  final int id;
  final String originalName;
  final String mimeType;
  final int size;
  final String url;
  final DateTime createdAt;

  Attachment({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.url,
    required this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      originalName: json['original_name'] ?? '',
      mimeType: json['mime_type'] ?? '',
      size: json['size'] ?? 0,
      url: json['url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isImage {
    return mimeType.startsWith('image/') ||
        originalName.toLowerCase().contains('.jpg') ||
        originalName.toLowerCase().contains('.jpeg') ||
        originalName.toLowerCase().contains('.png') ||
        originalName.toLowerCase().contains('.gif') ||
        originalName.toLowerCase().contains('.webp');
  }

  bool get isPdf {
    return mimeType.contains('pdf') ||
        originalName.toLowerCase().contains('.pdf');
  }

  bool get isDocument {
    return mimeType.contains('word') ||
        mimeType.contains('excel') ||
        originalName.toLowerCase().contains('.doc') ||
        originalName.toLowerCase().contains('.docx') ||
        originalName.toLowerCase().contains('.xls') ||
        originalName.toLowerCase().contains('.xlsx');
  }
}

