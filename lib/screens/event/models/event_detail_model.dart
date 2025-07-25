enum EventStatus {
  upcoming,
  active,
  finish,
  canceled,
}

extension EventStatusExtension on EventStatus {
  static EventStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return EventStatus.upcoming;
      case 'active':
        return EventStatus.active;
      case 'finish':
        return EventStatus.finish;
      case 'canceled':
        return EventStatus.canceled;
      default:
        throw ArgumentError('Invalid EventStatus: $status');
    }
  }

  String toShortString() {
    return toString().split('.').last;
  }
}

class EventDetailModel {
  final String id;
  final String name;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String locationName;
  final int type;
  final String typeName;
  final EventStatus status;
  final bool forAllBatches;
  // Properti 'batches' tidak ada dalam output JSON dari query yang kamu berikan,
  // jadi kita hapus dari model ini.
  // final List<String>? batches; // Dihapus
  final int attendedCount;
  final int eligibleCount;
  final String qrValue;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdByUserId;
  // Properti baru dari query SQL:
  final bool isAttended;

  EventDetailModel({
    required this.id,
    required this.name,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.locationName,
    required this.type,
    required this.typeName,
    required this.status,
    required this.forAllBatches,
    // this.batches, // Dihapus dari konstruktor
    required this.attendedCount,
    required this.eligibleCount,
    required this.qrValue,
    required this.createdAt,
    this.updatedAt,
    required this.createdByUserId,
    required this.isAttended, // Ditambahkan
  });

  // Factory constructor untuk membuat objek EventDetail dari JSON (Map<String, dynamic>)
  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    return EventDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      // Konversi string waktu ISO 8601 ke DateTime
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String,
      locationName: json['location_name'] as String,
      type: json['type'] as int,
      typeName: json['type_name'] as String,
      // Konversi string status ke enum EventStatus
      status: EventStatusExtension.fromString(json['status'] as String),
      forAllBatches: json['for_all_batches'] as bool,
      // 'batches' tidak ada di JSON, jadi baris ini dihilangkan
      // batches: (json['batches'] as List?)?.map((e) => e as String).toList(),
      attendedCount: json['attended_count'] as int,
      eligibleCount: json['eligible_count'] as int,
      qrValue: json['qr_value'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      // Penanganan 'updated_at' yang bisa null
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      createdByUserId: json['created_by_user_id'] as String,
      isAttended: json['is_attended'] as bool, // Konversi boolean
    );
  }

  // Metode untuk mengonversi objek EventDetail kembali ke JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      // Konversi DateTime kembali ke string ISO 8601
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'location_name': locationName,
      'type': type,
      'type_name': typeName,
      // Konversi enum kembali ke string
      'status': status.toShortString(),
      'for_all_batches': forAllBatches,
      // 'batches' tidak ada di JSON, jadi baris ini dihilangkan
      // 'batches': batches,
      'attended_count': attendedCount,
      'eligible_count': eligibleCount,
      'qr_value': qrValue,
      'created_at': createdAt.toIso8601String(),
      // Penanganan 'updated_at' yang bisa null
      'updated_at': updatedAt?.toIso8601String(),
      'created_by_user_id': createdByUserId,
      'is_attended': isAttended, // Tambahkan properti baru
    };
  }
}
