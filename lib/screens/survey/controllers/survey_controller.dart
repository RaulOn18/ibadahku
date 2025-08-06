import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/screens/survey/models/survey_questions_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SurveyController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  RxList<SurveyQuestionModel> surveyQuestionList = <SurveyQuestionModel>[].obs;

  Future<void> fetchSurveyQuestion({required String id}) async {
    try {
      log("Fetching survey questions: $id");
      final response = await _client.rpc("get_survey_questions", params: {
        "p_survey_id": id,
      }) as List<dynamic>;
      log("Survey questions response: $response");

      if (response.isNotEmpty) {
        surveyQuestionList.value = response
            .map((item) =>
                SurveyQuestionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e, stackTrace) {
      log("Error: when fetch survey questions $e $stackTrace");
    }
  }

  Future<void> submitSurvey({
    required String surveyId,
    required List<SurveyQuestionModel> answerList,
  }) async {
    try {
      var request = {
        "p_survey_id": surveyId,
        "p_user_id": _client.auth.currentUser!.id,
        "p_answers": answerList
            .map((item) => {
                  "question_id": item.questionId,
                  "answer": item.answers.value,
                })
            .toList(),
      };

      log("Request: $request ${(request['p_answers'] as dynamic).length}");
      final response =
          await _client.rpc("submit_survey_response", params: request);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(Get.context!)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(
                  response['message'] ?? "Terima kasih telah mengisi survey."),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
        Get.offAllNamed(Routes.home);
      } else {
        ScaffoldMessenger.of(Get.context!)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(response['message'] ??
                  "Gagal mengisi survey, silahkan coba lagi."),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
      }

      log("Submit survey response: $response");
    } catch (e, stackTrace) {
      log("Error: when submit survey $e $stackTrace");
    }
  }
}
