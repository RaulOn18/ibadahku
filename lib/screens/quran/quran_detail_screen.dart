import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/controllers/quran_controller.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class QuranDetailScreen extends StatefulWidget {
  const QuranDetailScreen({super.key});

  @override
  State<QuranDetailScreen> createState() => _QuranDetailScreenState();
}

class _QuranDetailScreenState extends State<QuranDetailScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    RxInt numberSurah = Get.arguments;

    var quranController = Get.put(QuranController());

    quranController.fetchSurahByIdFromJsonFile(numberSurah.value);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(() =>
            Text(quranController.surahDetail.value.info?.surat.nama.id ?? "")),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.arrow_left_1),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              controller: scrollController,
              children: [
                Obx(
                  () => Visibility(
                    visible: !(numberSurah.value == 9),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount:
                        quranController.surahDetail.value.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var ayat = quranController.surahDetail.value.data?[index];
                      if (numberSurah.value == 1 && index == 0) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Utils.kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              child: Text(
                                "${index + 1}.",
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          ayat?.arab ?? '',
                                          textAlign: TextAlign.end,
                                          locale: const Locale('ar', 'SA'),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ayat?.text ?? '',
                                          textAlign: TextAlign.start,
                                          locale: const Locale('ar', 'SA'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 64,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -4),
              )
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      if (numberSurah.value != 144) {
                        numberSurah.value = numberSurah.value + 1;
                        quranController
                            .fetchSurahByIdFromJsonFile(numberSurah.value);
                        scrollController.animateTo(0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.ease);
                      }
                    },
                    icon: const Icon(IconsaxPlusLinear.arrow_left_1)),
                IconButton(
                  onPressed: () {
                    if (numberSurah.value != 1) {
                      numberSurah.value = numberSurah.value - 1;
                      quranController
                          .fetchSurahByIdFromJsonFile(numberSurah.value);
                      scrollController.animateTo(0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease);
                    } else {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text("First Surah"),
                            behavior: SnackBarBehavior.floating,
                            showCloseIcon: true,
                          ),
                        );
                    }
                  },
                  icon: const Icon(IconsaxPlusLinear.arrow_right_3),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
