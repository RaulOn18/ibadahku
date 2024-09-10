import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ibadahku/utils/utils.dart';

class QuranController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  RxList<dynamic> allSurah = <dynamic>[].obs;

  RxBool isLoading = false.obs;

  void fetchAllSurah() {
    isLoading.value = true;
    _dio.get("${Utils.baseUrl}/quran/surat/semua").then((response) {
      if (response.data != null) {
        if (response.data['data'] != null) {
          allSurah.value = response.data['data'];
        }
      }
    }).whenComplete(() => isLoading.value = false);
  }
}
