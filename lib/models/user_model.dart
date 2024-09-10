import 'package:ibadahku/models/angkatan_model.dart';
import 'package:ibadahku/models/major_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  MajorModel? major;
  AngkatanModel? angkatan;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.major,
    this.angkatan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      major: json['major'] != null ? MajorModel.fromJson(json['major']) : null,
      angkatan: json['angkatan'] != null
          ? AngkatanModel.fromJson(json['angkatan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'major': major,
      'angkatan': angkatan,
    };
  }
}
