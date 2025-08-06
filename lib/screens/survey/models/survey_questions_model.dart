import 'package:get/get.dart';

class SurveyQuestionModel {
  final String sectionId;
  final String sectionTitle;
  final String variable;
  final String dimension;
  final String questionId;
  final String questionText;
  final int sortOrder;
  final RxString answers;

  SurveyQuestionModel({
    required this.sectionId,
    required this.sectionTitle,
    required this.variable,
    required this.dimension,
    required this.questionId,
    required this.questionText,
    required this.sortOrder,
  }) : answers = "".obs;

  factory SurveyQuestionModel.fromJson(Map<String, dynamic> json) =>
      SurveyQuestionModel(
        sectionId: json["section_id"],
        sectionTitle: json["section_title"],
        variable: json["variable"],
        dimension: json["dimension"],
        questionId: json["question_id"],
        questionText: json["question_text"],
        sortOrder: json["sort_order"],
      );

  Map<String, dynamic> toJson() => {
        "section_id": sectionId,
        "section_title": sectionTitle,
        "variable": variable,
        "dimension": dimension,
        "question_id": questionId,
        "question_text": questionText,
        "sort_order": sortOrder,
      };
}
