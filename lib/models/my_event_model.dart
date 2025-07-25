class MyEvent {
  final String id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String locationName;
  final String status;
  final String createdByUserId;
  final String qrValue;
  final int type;
  final String typeName;
  final bool forAllBatches;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int attendedCount;
  final int eligibleCount;
  final bool isAttended;

  MyEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.locationName,
    required this.status,
    required this.createdByUserId,
    required this.qrValue,
    required this.type,
    required this.typeName,
    required this.forAllBatches,
    required this.createdAt,
    this.updatedAt,
    required this.attendedCount,
    required this.eligibleCount,
    required this.isAttended,
  });

  factory MyEvent.fromJson(Map<String, dynamic> json) {
    return MyEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String,
      locationName: json['location_name'] as String,
      status: json['status'] as String,
      createdByUserId: json['created_by_user_id'] as String,
      qrValue: json['qr_value'] as String,
      type: json['type'] as int,
      typeName: json['type_name'] as String,
      forAllBatches: json['for_all_batches'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      attendedCount: json['attended_count'] as int,
      eligibleCount: json['eligible_count'] as int,
      isAttended: json['is_attended'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'location_name': locationName,
      'status': status,
      'created_by_user_id': createdByUserId,
      'qr_value': qrValue,
      'type': type,
      'type_name': typeName,
      'for_all_batches': forAllBatches,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'attended_count': attendedCount,
      'eligible_count': eligibleCount,
      'is_attended': isAttended,
    };
  }
}