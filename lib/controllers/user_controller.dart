import 'dart:developer';

import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  get user => userModel.value;
  get id => _client.auth.currentUser!.id;

  void getUser() {
    if (id != null) {
      log("Fetching user: $id");
      _client.from('users').select().eq('id', id).single().then((value) {
        log("User response: $value");
        userModel.value = UserModel.fromJson(value);
        log("User: ${userModel.value!.name}");
        update();
      });
    }
  }

  void logout() async {
    await _client.auth.signOut();
    Get.offAllNamed(Routes.home);
  }
}
