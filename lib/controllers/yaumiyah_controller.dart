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
            "value": false.obs
          },
          {
            "id": "71993b78-ac72-414c-b3cb-b1904fa8cf9f",
            "title": "Sholat Dzuhur",
            "value": false.obs
          },
          {
            "id": "efb1bd56-3ee2-4b96-b7d3-12e6151e5cbe",
            "title": "Sholat Ashar",
            "value": false.obs
          },
          {
            "id": "b321beca-fa16-4ed5-a2e0-e07b2f8f75f5",
            "title": "Sholat Maghrib",
            "value": false.obs
          },
          {
            "id": "9d8763ba-285a-43eb-b87c-d98597f8fa74",
            "title": "Sholat Isya",
            "value": false.obs
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
            "value": false.obs
          },
          {
            "id": "5085f838-37be-4767-9b4c-c5290d7a1dbe",
            "title": "Sholat Dhuha",
            "value": false.obs
          },
          {
            "id": "d1ddc7b2-e878-4842-9d32-0998c56f0038",
            "title": "Sholat Qobla Subuh",
            "value": false.obs
          },
          {
            "id": "50509548-163a-4155-9e0e-5114daeac22a",
            "title": "Sholat Qobla Dzuhur",
            "value": false.obs
          },
          {
            "id": "f1fa0ac0-f249-403f-831c-3c1ec330850c",
            "title": "Sholat Ba'da Dzuhur",
            "value": false.obs
          },
          {
            "id": "67f2b4c9-e21c-427a-92ce-ae63948fa08a",
            "title": "Sholat Ba'da Maghrib",
            "value": false.obs
          },
          {
            "id": "182ae56b-ebca-4757-9a48-f233b45a30c0",
            "title": "Sholat Ba'da Isya",
            "value": false.obs
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
            "value": false.obs
          },
          {
            "id": "40db0467-0ce5-4652-abab-b89fc2fa53db",
            "title": "Membaca Surat Al-Kahfi",
            "value": false.obs,
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
            "value": false.obs
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
            "value": false.obs
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
            "value": false.obs
          },
          {
            "id": "c456c22a-1961-442a-923f-2a5481e73bcc",
            "title": "Istighfar",
            "value": false.obs
          },
          {
            "id": "c56d76c3-2ab7-4a67-86af-bf4a326a9dd8",
            "title": "Sholawat",
            "value": false.obs
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
            "value": false.obs
          },
          {
            "id": "ca609d47-1862-452f-be08-cf5f84d0fc29",
            "title": "Menyimak kajian Marifatullah",
            "value": false.obs
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
            "value": false.obs
          },
        ]
      }.obs,
    ]);
  }

  Future<void> insertDailyRecord(
      String amalanTypeId, String subAmalanId, bool isCompleted) async {
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
            .update({'is_completed': isCompleted})
            .eq('user_id', _supabaseClient.auth.currentUser!.id)
            .eq('date', DateFormat('y-MM-dd').format(selectedDate.value))
            .eq('amalan_type_id', amalanTypeId)
            .eq('sub_amalan_id', subAmalanId);
        log('Updated daily record');
      } else {
        await _supabaseClient.from('daily_records').insert({
          'user_id': _supabaseClient.auth.currentUser!.id,
          'date': DateFormat('y-MM-dd').format(selectedDate.value),
          'amalan_type_id': amalanTypeId,
          'sub_amalan_id': subAmalanId,
          'is_completed': isCompleted,
        });
        log('Inserted daily record');
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
    for (var category in yaumiyahList) {
      for (var ibadah in category['list_ibadah']) {
        ibadah['value'].value = false;
      }
    }

    var response = await _supabaseClient
        .from('daily_records')
        .select('amalan_type_id, sub_amalan_id, is_completed')
        .eq('user_id', '${_supabaseClient.auth.currentUser?.id}')
        .eq('date', date);

    log("fetch daily record $date: $response");

    for (var record in response) {
      updateYaumiyahList(record['amalan_type_id'], record['sub_amalan_id'],
          record['is_completed']);
    }

    // Set up real-time subscription
    // _subscription = _supabaseClient
    //     .channel('public:daily_records')
    //     .onBroadcast(.postgresChanges,
    //         ChannelFilter(
    //           event: '*',
    //           schema: 'public',
    //           table: 'daily_records',
    //           filter: 'user_id=eq.${_supabaseClient.auth.currentUser?.id}',
    //         ), (payload, [ref]) {
    //       if (payload['new'] != null) {
    //         updateYaumiyahList(
    //           payload['new']['amalan_type_id'],
    //           payload['new']['sub_amalan_id'],
    //           payload['new']['is_completed'],
    //         );
    //       }
    //     })
    //     .subscribe();
  }

  void updateYaumiyahList(
      String amalanTypeId, String subAmalanId, bool isCompleted) {
    for (var category in yaumiyahList) {
      if (category['id'] == amalanTypeId) {
        for (var ibadah in category['list_ibadah']) {
          if (ibadah['id'] == subAmalanId) {
            ibadah['value'].value = isCompleted;
            break;
          }
        }
        break;
      }
    }
  }
}
