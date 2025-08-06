class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final bool isPublished;
  final String targetType;
  final bool read;
  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.isPublished,
    required this.targetType,
    required this.read,
  });
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isPublished: json['is_published'] as bool,
      targetType: json['target_type'] as String,
      read: json['read'] as bool,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'is_published': isPublished,
      'target_type': targetType,
      'read': read
    };
  }
}
