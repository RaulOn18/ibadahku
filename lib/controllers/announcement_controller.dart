import 'dart:developer';

import 'package:get/get.dart';
import 'package:ibadahku/models/announcement_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  RxList<AnnouncementModel?> announcementList = <AnnouncementModel>[].obs;

  Future<void> fetchAnnouncement() async {
    try {
      final response = await _client.rpc("get_user_announcements", params: {
        "input_user_id": _client.auth.currentUser!.id,
      });
      announcementList.value = (response as List)
          .map((item) =>
              AnnouncementModel.fromJson(item as Map<String, dynamic>))
          .toList()
          .cast<AnnouncementModel>();
    } catch (e, stackTrace) {
      log("Error (fetchAnnouncement): $e\n$stackTrace");
    }
  }
}
