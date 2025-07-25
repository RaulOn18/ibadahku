import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:ibadahku/constants/box_storage.dart';
import 'package:ibadahku/core/provider/api/api_constants.dart';
import 'package:ibadahku/screens/app_version_view.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // RxBool isLoading = true.obs;

  final RxList<dynamic> allCity = <dynamic>[].obs;
  final TextEditingController searchController = TextEditingController();

  final RxString currentCity = 'Kota. Bandung'.obs;
  final RxString currentCityId = '1219'.obs;
  final RxString currentHijrDate = ''.obs;

  final RxMap<String, dynamic> prayerTime = <String, dynamic>{}.obs;
  final RxString currentPrayerTime = '--:--'.obs;
  final RxString currentPrayerTimeName = '-'.obs;
  final RxString timeAhead = '-'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocationData();
  }

  void _initializeLocationData() async {
    final cityNameStorage = await BoxStorage().get("name_current_city");
    final cityIdStorage = await BoxStorage().get("id_current_city");

    if (cityNameStorage != null && cityNameStorage.isNotEmpty) {
      currentCity.value = cityNameStorage;
    }

    if (cityIdStorage != null && cityIdStorage.isNotEmpty) {
      currentCityId.value = cityIdStorage;
    }
  }

  void changeCurrentLocation(String city, String cityId) {
    BoxStorage().save("name_current_city", city);
    BoxStorage().save("id_current_city", cityId);
    currentCity.value = city;
    currentCityId.value = cityId;
    currentPrayerTime.value = "--:--";
    currentPrayerTimeName.value = "-";
    requestDataPrayerTime(cityId, DateTime.now());
  }

  Future<void> requestDataPrayerTime(String cityId, DateTime date) async {
    try {
      final response = await _dio.get(
        "${ApiConstants.baseUrl}sholat/jadwal/$cityId/${date.year}/${date.month}/${date.day}/",
      );

      if (response.data != null && response.data['data'] != null) {
        log("Prayer time response: ${response.data['data']}");
        prayerTime.value = response.data["data"]['jadwal'];
        if (prayerTime.isNotEmpty) {
          _updateCurrentPrayerTime(date);
        }
      }
    } catch (e) {
      debugPrint("Error fetching prayer time: $e");
    }
  }

  void _updateCurrentPrayerTime(DateTime date) {
    prayerTime.forEach((key, value) {
      if (key != "tanggal" && key != "date") {
        final prayerDateTime = _parsePrayerDateTime(date, value);
        if (prayerDateTime.isAfter(date) &&
            currentPrayerTime.value == "--:--") {
          _setCurrentPrayerTime(key, value, prayerDateTime);
          return;
        }
      }
    });
  }

  DateTime _parsePrayerDateTime(DateTime date, String time) {
    return DateFormat("yyyy-MM-dd HH:mm").parse(
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $time:00",
    );
  }

  void _setCurrentPrayerTime(String key, String value, DateTime prayerTime) {
    currentPrayerTime.value = value;
    currentPrayerTimeName.value = key;
    final difference = prayerTime.difference(DateTime.now());
    timeAhead.value =
        "${difference.inHours} jam ${difference.inMinutes.abs() % 60} menit menjelang sholat ${key.capitalize}";
  }

  Future<void> requestDataHijrCalendar() async {
    try {
      final response = await _dio.get("${ApiConstants.baseUrl}cal/hijr");
      if (response.data != null && response.data['data']['date'] != null) {
        currentHijrDate.value = response.data["data"]["date"][1];
      }
    } catch (e) {
      debugPrint("Error fetching Hijr calendar: $e");
    }
  }

  Future<void> requestAllDataCity() async {
    try {
      final response =
          await _dio.get("${ApiConstants.baseUrl}sholat/kota/semua");
      if (response.data != null) {
        allCity.value = response.data["data"];
      }
    } catch (e) {
      debugPrint("Error fetching all cities: $e");
    }
  }

  Future<void> searchCity(String city) async {
    try {
      final response =
          await _dio.get("${ApiConstants.baseUrl}sholat/kota/cari/$city");
      if (response.data != null && response.data['data'] != null) {
        allCity.value = response.data['data'];
      }
    } catch (e) {
      log("Error searching city: $e");
    }
  }

  Future<void> checkUpdate() async {
    try {
      var version = await _supabaseClient.from('app_version').select().single();
      final currentVersion = version['latest_version'].toString();
      final link = Uri.parse(version['link'].toString());
      final latestVersion =
          await PackageInfo.fromPlatform().then((info) => info.version);
      if (currentVersion != latestVersion) {
        // Show update dialog
        showModalBottomSheet(
          isDismissible: false,
          constraints:
              BoxConstraints(maxWidth: Get.width, maxHeight: Get.height * 0.4),
          context: Get.context!,
          builder: (context) =>
              AppVersionView(version: currentVersion, link: link),
        );
      }
    } catch (e, stackTrace) {
      log("Error checking update: $e, $stackTrace");
    }
  }
}
