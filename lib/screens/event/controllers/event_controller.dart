import 'dart:developer';

import 'package:get/get.dart';
import 'package:ibadahku/models/my_event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;

  RxBool isFetchingEvent = false.obs;
  RxBool isCheckingAttendance = false.obs;

  RxList<MyEvent> eventList = <MyEvent>[].obs;
  RxList<MyEvent> activeEventList = <MyEvent>[].obs;
  RxList<Map<String, dynamic>> filterCategory = <Map<String, dynamic>>[
    {
      "name": "Semua",
      "status": "",
    },
    {
      "name": "Aktif",
      "status": "active",
    },
    {
      "name": "Akan Datang",
      "status": "upcoming",
    },
    {
      "name": "Selesai",
      "status": "finish",
    },
  ].obs;

  RxString selectedCategory = "".obs;

  Future<void> fetchEventForCurrentUser() async {
    try {
      final params = {
        "p_user_id": currentUser?.id.toString() ?? "",
        if (selectedCategory.value.isNotEmpty)
          "p_status_filter": selectedCategory.value,
      };
      isFetchingEvent.value = true;
      final response = await _client.rpc(
        "get_user_events_with_summary",
        params: params,
      );

      eventList.value = (response as List)
          .map((item) => MyEvent.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      log("Error fetching events: $e\n$stackTrace");
      // Get.snackbar(
      //   'Error',
      //   'Failed to fetch events: ${e.toString()}',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      isFetchingEvent.value = false;
    }
  }

  Future<void> fetchActiveEvent() async {
    try {
      final params = {
        "p_user_id": currentUser!.id.toString(),
        "p_status_filter": 'active',
      };
      final response = await _client.rpc(
        "get_user_events_with_summary",
        params: params,
      );

      activeEventList.value = (response as List)
          .map((item) => MyEvent.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      log("Error fetching active events: $e\n$stackTrace");
      // Get.snackbar(
      //   'Error',
      //   'Failed to fetch active events: ${e.toString()}',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  Future<bool> checkIfHaveAttended(String eventId) async {
    try {
      final response = await _client
          .from('event_attendances')
          .select()
          .eq('event_id', eventId)
          .eq('user_id', currentUser!.id)
          .single();

      if (response.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
