import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/components/custom_button.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/utils/utils.dart';

class SurveyInfoView extends StatefulWidget {
  final String surveyId;
  const SurveyInfoView({super.key, required this.surveyId});

  @override
  State<SurveyInfoView> createState() => _SurveyInfoViewState();
}

class _SurveyInfoViewState extends State<SurveyInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        spacing: 6,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "assets/images/vector.webp",
              ),
            ),
          ),
          const Text(
            "Bantu Kami Menjadi Lebih Baik",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Assalamu'alaikum! Kami sangat menghargai masukan dari Anda. Mari luangkan waktu sejenak untuk berbagi pengalaman Anda menggunakan Ibadahku. Setiap pendapat Anda akan membantu kami menghadirkan aplikasi yang lebih bermanfaat.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          CustomButton(
            backgroundColor: Utils.kPrimaryColor,
            textColor: Colors.white,
            onTap: () {
              Get.toNamed(Routes.survey, arguments: widget.surveyId);
            },
            isLoading: false,
            text: "Mulai",
          )
        ],
      ),
    ));
  }
}
