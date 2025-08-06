import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/components/custom_button.dart';
import 'package:ibadahku/screens/survey/controllers/survey_controller.dart';
import 'package:ibadahku/screens/survey/models/survey_answers_model.dart';
import 'package:ibadahku/utils/utils.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  SurveyController surveyController = Get.put(SurveyController());
  String argsId = Get.arguments ?? "";
  RxInt currentQuestionIndex = 0.obs;

  RxList<SurveyAnswerModel> answerList = <SurveyAnswerModel>[
    SurveyAnswerModel(
      id: "1",
      fullName: "Sangat Tidak Setuju",
      shortName: "STS",
      description: "Sangat Tidak Setuju",
    ),
    SurveyAnswerModel(
      id: "2",
      fullName: "Tidak Setuju",
      shortName: "TS",
      description: "Tidak Setuju",
    ),
    SurveyAnswerModel(
      id: "3",
      fullName: "Kurang Setuju",
      shortName: "KS",
      description: "Kurang Setuju",
    ),
    SurveyAnswerModel(
      id: "4",
      fullName: "Setuju",
      shortName: "S",
      description: "Setuju",
    ),
    SurveyAnswerModel(
      id: "5",
      fullName: "Sangat Setuju",
      shortName: "SS",
      description: "Sangat Setuju",
    ),
  ].obs;

  @override
  void initState() {
    super.initState();
    surveyController.fetchSurveyQuestion(id: argsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Survey", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Utils.kPrimaryColor,
        foregroundColor: Utils.kWhiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xfff7f7f7),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsetsGeometry.all(12),
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          "${surveyController.surveyQuestionList.where((element) => element.answers.value != "").length} dari ${surveyController.surveyQuestionList.length} Pertanyaan",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utils.kPrimaryColor,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          "${surveyController.surveyQuestionList.isEmpty ? 0 : (surveyController.surveyQuestionList.where((element) => element.answers.value != "").length / surveyController.surveyQuestionList.length * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Utils.kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => LinearProgressIndicator(
                      value: surveyController.surveyQuestionList.isEmpty
                          ? 0
                          : surveyController.surveyQuestionList
                                  .where(
                                      (element) => element.answers.value != "")
                                  .length /
                              surveyController.surveyQuestionList.length,
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(
            () => surveyController.surveyQuestionList.isEmpty
                ? const Center(child: Text("Tidak ada pertanyaan"))
                : Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        spacing: 20,
                        children: [
                          Text(
                            surveyController
                                .surveyQuestionList[currentQuestionIndex.value]
                                .questionText,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) => Obx(
                                () => CheckboxListTile.adaptive(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    tileColor: Utils.kWhiteColor,
                                    dense: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Utils.kGreyColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    title: Text(answerList[index].fullName,
                                        style: const TextStyle(fontSize: 16)),
                                    value: answerList[index].id ==
                                        surveyController
                                            .surveyQuestionList[
                                                currentQuestionIndex.value]
                                            .answers
                                            .value,
                                    onChanged: (value) {
                                      surveyController
                                          .surveyQuestionList[
                                              currentQuestionIndex.value]
                                          .answers
                                          .value = answerList[index].id;
                                      if (currentQuestionIndex.value <
                                          surveyController
                                                  .surveyQuestionList.length -
                                              1) {
                                        currentQuestionIndex.value++;
                                      }
                                    }),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 4,
                              ),
                              itemCount: answerList.length,
                            ),
                          ),
                          Row(
                            spacing: 12,
                            children: [
                              if (currentQuestionIndex.value > 0)
                                Expanded(
                                  child: CustomButton(
                                    backgroundColor: Utils.kWhiteColor,
                                    textColor: Utils.kPrimaryColor,
                                    onTap: () {
                                      if (currentQuestionIndex.value > 0) {
                                        currentQuestionIndex.value--;
                                      }
                                    },
                                    isLoading: false,
                                    text: "Sebelumnya",
                                  ),
                                ),
                              if (currentQuestionIndex.value <
                                  surveyController.surveyQuestionList.length -
                                      1)
                                Expanded(
                                  child: CustomButton(
                                    backgroundColor: Utils.kPrimaryColor,
                                    textColor: Utils.kWhiteColor,
                                    onTap: () {
                                      // check apakah sudah dijawab, kalau belum jangan lanjut
                                      if (surveyController
                                          .surveyQuestionList[
                                              currentQuestionIndex.value]
                                          .answers
                                          .value
                                          .isEmpty) {
                                        ScaffoldMessenger.of(Get.context!)
                                          ..clearSnackBars()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Silahkan pilih jawaban terlebih dahulu",
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              showCloseIcon: true,
                                            ),
                                          );
                                        return;
                                      }

                                      if (currentQuestionIndex.value <
                                          surveyController
                                                  .surveyQuestionList.length -
                                              1) {
                                        currentQuestionIndex.value++;
                                      }
                                    },
                                    isLoading: false,
                                    text: "Selanjutnya",
                                  ),
                                ),
                              if (currentQuestionIndex.value ==
                                  surveyController.surveyQuestionList.length -
                                      1)
                                Expanded(
                                  child: CustomButton(
                                    backgroundColor: Utils.kSecondaryColor,
                                    textColor: Utils.kWhiteColor,
                                    onTap: () {
                                      // TODO: Submit survey
                                      surveyController.submitSurvey(
                                        surveyId: argsId,
                                        answerList:
                                            surveyController.surveyQuestionList,
                                      );
                                    },
                                    isLoading: false,
                                    text: "Selesai",
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
