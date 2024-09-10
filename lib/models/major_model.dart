class MajorModel {
  String id;
  String name;
  String shortName;

  MajorModel({required this.id, required this.name, required this.shortName});

  factory MajorModel.fromJson(Map<String, dynamic> json) {
    return MajorModel(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
    };
  }
}
