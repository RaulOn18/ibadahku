import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/box_storage.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/screens/event/controllers/event_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;

  var emailController = TextEditingController();
  var emailFocusNOde = FocusNode();
  var passwordController = TextEditingController();

  var nameController = TextEditingController();
  var emailSignUpController = TextEditingController();
  var passwordSignUpController = TextEditingController();
  var angkatanController = TextEditingController();
  var majorController = TextEditingController();

  var allUser = [].obs;
  var allMajor = [].obs;
  var allBatch = [].obs;

  RxBool isHidePassword = true.obs;
  RxBool isRemember = true.obs;
  RxBool isLoading = false.obs;

  RxBool isSendingEmail = false.obs;

  RxBool isSignUp = false.obs;

  void login() async {
    isLoading.value = true;
    await client.auth
        .signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((value) {
      isLoading.value = false;
      if (isRemember.value) {
        BoxStorage().save("email", emailController.text);
      }

      emailController.clear();
      passwordController.clear();

      Get.back();
      Get.put(EventController()).fetchEventForCurrentUser();
      Get.put(EventController()).fetchActiveEvent();
      Get.snackbar("Success", "Login Success");
    }).onError((error, stackTrace) {
      isLoading.value = false;
      if (isRemember.value) {}
      Get.snackbar("Error", error.toString());
      log(error.toString());
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  void registerall() async {
    try {
      isLoading.value = true;
      var newData = [
        {
          "id": 234,
          "name": "Amalia Nur Azizah ",
          "email": "nurazizahamalia427@gmail.com",
          "angkatan": 4,
          "major": 2,
          "created_at": "2025-03-03 01:56:18.185044+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 236,
          "name": "Ibrahim Juliardi Sastranegara",
          "email": "ibrahim772002@gmail.com",
          "angkatan": 6,
          "major": 1,
          "created_at": "2025-03-03 01:56:26.068466+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 239,
          "name": "Muhammad Abid Dzikri",
          "email": "mabiddzikri@gmail.com",
          "angkatan": 6,
          "major": 1,
          "created_at": "2025-03-03 01:56:48.944235+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 240,
          "name": "M WIRA RAMDANI MAULANA ",
          "email": "wiraramdani026@gmail.com",
          "angkatan": 6,
          "major": 2,
          "created_at": "2025-03-03 01:56:49.139909+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 241,
          "name": "Aisyah khoirunnisa ",
          "email": "khoirunnisaaisyah249@gmail.com",
          "angkatan": 6,
          "major": 2,
          "created_at": "2025-03-03 01:56:49.747404+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 242,
          "name": "Agus Maulana",
          "email": "agusmaulana120803@gmail.com",
          "angkatan": 6,
          "major": 2,
          "created_at": "2025-03-03 01:56:58.839866+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 243,
          "name": "Alfi  Ikliil Labiib ",
          "email": "alfiikliillabiib@gmail.com",
          "angkatan": 6,
          "major": 1,
          "created_at": "2025-03-03 01:56:58.907964+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 244,
          "name": "Siti Risa Afifah Nur Fadilah ",
          "email": "sitirisaafifahnf@gmail.com",
          "angkatan": 6,
          "major": 1,
          "created_at": "2025-03-03 01:57:11.571705+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 245,
          "name": "Annasya Shafa Adicha",
          "email": "shafaadicha@gmail.com",
          "angkatan": 3,
          "major": 1,
          "created_at": "2025-03-03 01:57:27.971264+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 246,
          "name": "Reynaldi Real Ibrahim",
          "email": "reynaldireal404@gmail.com",
          "angkatan": 6,
          "major": 2,
          "created_at": "2025-03-03 01:57:33.357238+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 247,
          "name": "Annasya Shafa Adicha",
          "email": "shafaadicha08@gmail.com",
          "angkatan": 3,
          "major": 1,
          "created_at": "2025-03-03 01:57:52.41699+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 248,
          "name": "M WIRA RAMDANI MAULANA ",
          "email": "wiraramdani026@gmail.com",
          "angkatan": 6,
          "major": 2,
          "created_at": "2025-03-03 01:58:18.481599+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 249,
          "name": "amirrulmuminin534@gmail.com",
          "email": "amirrulmuminin534@gmail.com",
          "angkatan": 4,
          "major": 1,
          "created_at": "2025-03-03 01:58:43.550763+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 250,
          "name": "Aisyah khoirunnisa ",
          "email": "khoirunnisaaisyah249@gmail.com",
          "angkatan": 6,
          "major": 1,
          "created_at": "2025-03-03 01:58:48.650466+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 251,
          "name": "Asriaini Fahrudin",
          "email": "asriainifahrudinn@gmail.com",
          "angkatan": 3,
          "major": 1,
          "created_at": "2025-03-03 01:58:51.230194+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 252,
          "name": "Amirrul Mu' Minin",
          "email": "amirrulmuminin534@gmail.com",
          "angkatan": 4,
          "major": 1,
          "created_at": "2025-03-03 02:46:27.419706+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 255,
          "name": "Bagus f",
          "email": "firman.bagus10@gmail.com",
          "angkatan": 1,
          "major": 1,
          "created_at": "2025-03-03 05:59:20.816773+00",
          "nim": null,
          "category_santri": null
        },
        {
          "id": 260,
          "name": "Fitri Maulani ",
          "email": "fitrimaulani127@gmail.com",
          "angkatan": 3,
          "major": 1,
          "created_at": "2025-04-10 06:55:19.959042+00",
          "nim": null,
          "category_santri": null
        }
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
              'role': '12f9953c-d48d-4bc7-aa0d-a67ef812e5d8',
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

  Future<void> getAllMajor() async {
    try {
      var response = await client.from('majors').select("*");
      log(response.toString());
    } catch (e, stackTrace) {
      log("Error: when register $e $stackTrace");
    }
  }

  Future<void> regsiter() async {
    try {
      isSignUp.value = true;
      var response = await client
          .from('users')
          .select("*")
          .eq('email', emailController.text);

      log(response.toString());

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(Get.context!)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("Email already exist"),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
        return;
      }

      if (emailSignUpController.text.isNotEmpty &&
          passwordSignUpController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          angkatanController.text.isNotEmpty &&
          majorController.text.isNotEmpty) {
        await client.auth
            .signUp(
                password: passwordSignUpController.text,
                email: emailSignUpController.text)
            .then((v) {
          client.from('users').insert({
            'id': v.user!.id,
            'email': emailSignUpController.text,
            'name': nameController.text,
            'batch': angkatanController.text,
            'major': majorController.text
          }).then((value) {
            log('user created successfully');
            Get.toNamed(Routes.login);
            ScaffoldMessenger.of(Get.context!)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text("You have been logged in"),
                  behavior: SnackBarBehavior.floating,
                  showCloseIcon: true,
                ),
              );

            emailSignUpController.clear();
            passwordSignUpController.clear();
            nameController.clear();
            angkatanController.clear();
            majorController.clear();
          }).onError((error, stackTrace) {
            log("Error: when register $error $stackTrace");
            ScaffoldMessenger.of(Get.context!)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Failed to register"),
                  behavior: SnackBarBehavior.floating,
                  showCloseIcon: true,
                ),
              );
          });
        });
      }
    } catch (e, stackTrace) {
      log("Error: when register $e $stackTrace");
    } finally {
      isSignUp.value = false;
    }
  }
}
