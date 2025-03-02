import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibadahku/models/quran_model.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:ibadahku/utils/utils.dart';

class QuranController extends GetxController {
  // final dio.Dio _dio = dio.Dio();
  RxList<dynamic> allSurah = <dynamic>[].obs;
  Rx<QuranModel> surahDetail = QuranModel().obs;
  RxBool isLoading = false.obs;
  RxBool isDetailLoading = false.obs;

  // void fetchAllSurah() {
  //   isLoading.value = true;
  //   _dio.get("${Utils.baseUrl}/quran/surat/semua").then((response) {
  //     if (response.data != null) {
  //       if (response.data['data'] != null) {
  //         allSurah.value = response.data['data'];
  //       }
  //     }
  //   }).whenComplete(() => isLoading.value = false);
  // }

  void fetchAllSurahFromJsonFile() async {
    isLoading.value = true;
    await rootBundle.loadString('assets/json/list_quran.json').then((value) {
      allSurah.value = jsonDecode(value);
      // log(jsonDecode(value).toString());
      isLoading.value = false;
    });
  }

  void fetchSurahByIdFromJsonFile(int id) async {
    isDetailLoading.value = true;
    log("Fetching surah detail: $id");
    await rootBundle
        .loadString('assets/json/list_surah/$id.json')
        .then((value) {
      // log("Surah detail response: $value");
      surahDetail.value = QuranModel.fromJson(jsonDecode(value));
      isDetailLoading.value = false;
    }).onError(
      (error, stackTrace) {
        isDetailLoading.value = false;
        log(error.toString());
      },
    );
  }
}
