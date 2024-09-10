class AngkatanModel {
  String id;
  String name;

  AngkatanModel({required this.id, required this.name});

  factory AngkatanModel.fromJson(Map<String, dynamic> json) {
    return AngkatanModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
