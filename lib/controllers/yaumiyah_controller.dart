import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class YaumiyahController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final RxList<RxMap<String, dynamic>> yaumiyahList =
      <RxMap<String, dynamic>>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxDouble overallPercentage = 0.0.obs;

  RealtimeChannel? _subscription;

  final List<String> r_dhuha = ['0', '2', '4', '6', '8', '10', '12'];
  final List<String> r_istighfar = [
    '0',
    '100',
    '200',
    '300',
    '400',
    '500',
    '600',
    '700',
    '800',
    '900',
    '1000'
  ];
  final List<String> r_shalawat = [
    '0',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100'
  ];

  @override
  void onInit() {
    super.onInit();
    initializeYaumiyahList();
    ever(
      selectedDate,
      (_) => fetchDailyRecord(
        DateFormat('y-MM-dd').format(selectedDate.value),
      ),
    );
  }

  @override
  void onClose() {
    _subscription?.unsubscribe();
    super.onClose();
  }

  void initializeYaumiyahList() {
    yaumiyahList.assignAll([
      {
        "id": "393c4e7b-ce87-4019-92f4-02edb7a0e473",
        "title": "Cinta Sholat Wajib",
        "color": Colors.cyan[50],
        "icon": IconsaxPlusLinear.calendar,
        "list_ibadah": [
          {
            "id": "b39db4e3-b072-46d8-a2d1-39cc2b79b370",
            "title": "Sholat Subuh",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "71993b78-ac72-414c-b3cb-b1904fa8cf9f",
            "title": "Sholat Dzuhur",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "efb1bd56-3ee2-4b96-b7d3-12e6151e5cbe",
            "title": "Sholat Ashar",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "b321beca-fa16-4ed5-a2e0-e07b2f8f75f5",
            "title": "Sholat Maghrib",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "9d8763ba-285a-43eb-b87c-d98597f8fa74",
            "title": "Sholat Isya",
            "value": "0".obs,
            "input_type": "checkbox"
          },
        ]
      }.obs,
      {
        "id": "3aee7b6b-70c0-42af-87e9-6ddf35eee155",
        "title": "Cinta Sholat Sunnah",
        "color": Colors.purple[50],
        "icon": IconsaxPlusLinear.calendar,
        "list_ibadah": [
          {
            "id": "6af1b94c-2fa7-4d53-95f2-e71cd922d915",
            "title": "Sholat Qiyamullail",
            "value": "0".obs,
            "input_type": "checkbox",
            "target_value": "3",
          },
          {
            "id": "5085f838-37be-4767-9b4c-c5290d7a1dbe",
            "title": "Sholat Dhuha",
            "value": "0".obs,
            "input_type": "dropdown",
            "options": r_dhuha
          },
          {
            "id": "d1ddc7b2-e878-4842-9d32-0998c56f0038",
            "title": "Sholat Qobla Subuh",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "50509548-163a-4155-9e0e-5114daeac22a",
            "title": "Sholat Qobla Dzuhur",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "f1fa0ac0-f249-403f-831c-3c1ec330850c",
            "title": "Sholat Ba'da Dzuhur",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "67f2b4c9-e21c-427a-92ce-ae63948fa08a",
            "title": "Sholat Ba'da Maghrib",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "182ae56b-ebca-4757-9a48-f233b45a30c0",
            "title": "Sholat Ba'da Isya",
            "value": "0".obs,
            "input_type": "checkbox"
          },
        ]
      }.obs,
      {
        "id": "01ec8955-8073-4dde-85c6-e410f6ef3a70",
        "title": "Cinta Qur'an",
        "color": Colors.green[50],
        "icon": IconsaxPlusLinear.book_1,
        "list_ibadah": [
          {
            "id": "eb7efa43-db9a-4d67-8cda-0927afca944b",
            "title": "Tilawah Al-Qur'an",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "40db0467-0ce5-4652-abab-b89fc2fa53db",
            "title": "Membaca Surat Al-Kahfi",
            "value": "0".obs,
            "input_type": "checkbox",
          },
        ]
      }.obs,
      {
        "id": "adbc7be9-59f0-436c-9427-cb2d55a5c7b6",
        "title": "Cinta Shaum",
        "color": Colors.pink[50],
        "icon": IconsaxPlusLinear.heart,
        "list_ibadah": [
          {
            "id": "dafd34da-ff82-4b46-b15b-bb3a5554c5a3",
            "title": "Shaum Sunnah",
            "value": "0".obs,
            "input_type": "checkbox"
          },
        ]
      }.obs,
      {
        "id": "ff147d1d-8d8c-49a6-91d0-939ccfa83333",
        "title": "Cinta Shodaqoh",
        "color": Colors.yellow[50],
        "icon": IconsaxPlusLinear.heart,
        "list_ibadah": [
          {
            "id": "334ee3d9-2fdb-47c7-ab29-3883c7ba0d04",
            "title": "Shodaqoh Maal (Harta)",
            "value": "0".obs,
            "input_type": "checkbox"
          },
        ]
      }.obs,
      {
        "id": "4154800c-b308-4205-98ae-7b19830dd257",
        "title": "Cinta Dzikir dan Sholawat",
        "color": Colors.teal[50],
        "icon": IconsaxPlusLinear.heart,
        "list_ibadah": [
          {
            "id": "c6939045-f759-4fcb-b04d-9404c0b32055",
            "title": "Dzikir Pagi - Petang",
            "value": "0".obs,
            "input_type": "dropdown",
            "options": ["0", "1"], // Add default options for dropdown items
          },
          {
            "id": "c456c22a-1961-442a-923f-2a5481e73bcc",
            "title": "Istighfar",
            "value": "0".obs,
            "input_type": "dropdown",
            "options": r_istighfar,
          },
          {
            "id": "c56d76c3-2ab7-4a67-86af-bf4a326a9dd8",
            "title": "Sholawat",
            "value": "0".obs,
            "input_type": "dropdown",
            "options": r_shalawat,
          },
        ]
      }.obs,
      {
        "id": "de348c6a-d90b-4efc-94e6-2ade73ba90c9",
        "title": "Cinta Ilmu",
        "color": Colors.green[50],
        "icon": IconsaxPlusLinear.heart,
        "list_ibadah": [
          {
            "id": "9a157b0a-72f7-43d7-baa9-46beeef6588c",
            "title": "Menyimak MQ Pagi",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "ca609d47-1862-452f-be08-cf5f84d0fc29",
            "title": "Menyimak kajian Marifatullah",
            "value": "0".obs,
            "input_type": "checkbox"
          },
          {
            "id": "34611147-ad1b-4b54-93c5-f314f4f273d9",
            "title": "Menyimak kajian Al-Hikam",
            "value": "0".obs,
            "input_type": "checkbox"
          },
        ]
      }.obs,
      {
        "id": "d8f2bb02-cd33-42bd-894a-540c9fe62a85",
        "title": "BR3T",
        "color": Colors.brown[50],
        "icon": IconsaxPlusLinear.heart,
        "list_ibadah": [
          {
            "id": "26db1218-fe9a-4956-a0e8-e04a7adcca95",
            "title": "BR3T Mandiri, Asrama, Lingkungan Kampus",
            "value": "0".obs,
            "input_type": "checkbox"
          },
        ]
      }.obs,
    ]);
  }

  Future<void> insertDailyRecord(
      String amalanTypeId, String subAmalanId, String value) async {
    try {
      final existingRecords = await _supabaseClient
          .from('daily_records')
          .select()
          .eq('user_id', _supabaseClient.auth.currentUser!.id)
          .eq('date', DateFormat('y-MM-dd').format(selectedDate.value))
          .eq('amalan_type_id', amalanTypeId)
          .eq('sub_amalan_id', subAmalanId);

      if (existingRecords.isNotEmpty) {
        await _supabaseClient
            .from('daily_records')
            .update({'value': int.parse(value)}) // Ensure value is string
            .eq('user_id', _supabaseClient.auth.currentUser!.id)
            .eq('date', DateFormat('y-MM-dd').format(selectedDate.value))
            .eq('amalan_type_id', amalanTypeId)
            .eq('sub_amalan_id', subAmalanId);
      } else {
        await _supabaseClient.from('daily_records').insert({
          'user_id': _supabaseClient.auth.currentUser!.id,
          'date': DateFormat('y-MM-dd').format(selectedDate.value),
          'amalan_type_id': amalanTypeId,
          'sub_amalan_id': subAmalanId,
          'value': int.tryParse(value), // Ensure value is string
        });
      }
    } catch (e) {
      log("Error inserting daily record: $e");
    }
  }

  Future<void> removeDailyRecord(
      String amalanTypeId, String subAmalanId) async {
    var response = await _supabaseClient
        .from('daily_records')
        .delete()
        .eq('user_id', '${_supabaseClient.auth.currentUser?.id}')
        .eq('date', DateFormat('y-MM-dd').format(selectedDate.value))
        .eq('amalan_type_id', amalanTypeId)
        .eq('sub_amalan_id', subAmalanId);

    log(response.toString());
  }

  Future<void> fetchDailyRecord(String date) async {
    // Reset all values to "0" first
    for (var category in yaumiyahList) {
      for (var ibadah in category['list_ibadah']) {
        ibadah['value'].value = "0";
      }
    }

    var response = await _supabaseClient
        .from('daily_records')
        .select()
        .eq('user_id', _supabaseClient.auth.currentUser!.id)
        .eq('date', date);

    log("fetch daily record $date: $response");

    for (var record in response) {
      updateYaumiyahList(record['amalan_type_id'], record['sub_amalan_id'],
          record['value'].toString() // Ensure value is string
          );
    }
  }

  void updateYaumiyahList(
      String amalanTypeId, String subAmalanId, String value) {
    for (var category in yaumiyahList) {
      if (category['id'] == amalanTypeId) {
        for (var ibadah in category['list_ibadah']) {
          if (ibadah['id'] == subAmalanId) {
            ibadah['value'].value = value;
            break;
          }
        }
        break;
      }
    }
  }
}
