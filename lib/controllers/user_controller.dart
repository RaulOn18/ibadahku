import 'dart:developer';

import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  RxBool isFetchingUser = false.obs;

  get user => userModel.value;
  get id => _client.auth.currentUser!.id;

  Future<void> fetchUser() async {
    if (id != null) {
      try {
        log("Fetching user: $id");
        isFetchingUser.value = true;
        await _client
            .from('users')
            .select()
            .eq('id', id)
            .single()
            .then((value) {
          log("User response: $value");
          userModel.value = UserModel.fromJson(value);
          log("User: ${userModel.value!.name}");
          update();
        });
      } catch (e, stackTrace) {
        log("Error: when fetch user $e $stackTrace");
      } finally {
        isFetchingUser.value = false;
      }
    }
  }

  void logout() async {
    await _client.auth.signOut();
    Get.offAllNamed(Routes.home);
  }
}
