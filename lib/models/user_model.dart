class UserModel {
  String id;
  String name;
  String email;
  // MajorModel? major;
  // BatchModel? batch;
  int? major;
  int? batch;
  String? photoProfile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.major,
    this.photoProfile,
    this.batch,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      // major: json['major'] != null ? MajorModel.fromJson(json['major']) : null,
      // batch: json['batch'] != null ? BatchModel.fromJson(json['batch'])
      //     : null,
      major: json['major'],
      photoProfile: json['photo_profile'],
      batch: json['batch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'major': major,
      'batch': batch,
    };
  }
}
