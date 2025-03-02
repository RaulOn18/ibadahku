import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  RxBool isHidePassword = true.obs;
  RxBool isRemember = false.obs;
  RxBool isLoading = false.obs;

  void login() async {
    isLoading.value = true;
    await client.auth
        .signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((value) {
      isLoading.value = false;
      Get.snackbar("Success", "Login Success");
      Get.toNamed(Routes.home);
    }).onError((error, stackTrace) {
      isLoading.value = false;
      Get.snackbar("Error", error.toString());
      log(error.toString());
    }).whenComplete(() {
      isLoading.value = false;
      emailController.clear();
      passwordController.clear();
    });
  }

  void register() async {
    try {
      isLoading.value = true;
      var newData = [
        {
          "id": 166,
          "name": "Muhammad Irham",
          "email": "mirham@gmail.com",
          "angkatan": 4,
          "major": 1,
          "created_at": "2024-10-03 03:08:18.337742+00"
        },
      ];

      log(newData.length.toString());

      for (var i = 0; i < newData.length; i++) {
        try {
          await client.auth
              .signUp(
                  password: "@!Tauhiid123",
                  email: newData[i]['email'].toString())
              .then((v) {
            client.from('users').insert({
              'id': v.user!.id,
              'email': newData[i]['email'].toString(),
              'name': newData[i]['name'].toString(),
              'batch': newData[i]['angkatan'].toString(),
              'major': newData[i]['major'].toString()
            }).then((value) {
              log('user created successfully [$i] ${newData[i]['email'].toString()}');
              isLoading.value = false;
              client.auth.signOut();
            }).onError((error, stackTrace) {
              log("Error: when register $error $stackTrace");
            });
          });
        } catch (e, stackTrace) {
          log("Error: when register $e $stackTrace");
        }
      }
    } catch (e, stackTrace) {
      log("Error: when register $e $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }
}
