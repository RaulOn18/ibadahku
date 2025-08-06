class SurveyAnswerModel {
  final String id;
  final String fullName;
  final String shortName;
  final String description;

  SurveyAnswerModel({
    required this.id,
    required this.fullName,
    required this.shortName,
    required this.description,
  });

  factory SurveyAnswerModel.fromJson(Map<String, dynamic> json) =>
      SurveyAnswerModel(
        id: json["id"],
        fullName: json["full_name"],
        shortName: json["short_name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "short_name": shortName,
        "description": description,
      };
}
