import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await GetStorage.init();
  initializeDateFormatting('id_ID', null);

  try {
    await Supabase.initialize(
        url: "https://bpclthqlkjnmyokrhzsh.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJwY2x0aHFsa2pubXlva3JoenNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQyODc0ODUsImV4cCI6MjAzOTg2MzQ4NX0.2n1zWv85IIdhqjeHyBvU1lp1ZoDopePRFuh4KVf1pAY");
  } catch (e, stackTrace) {
    log("Error initializing supabase: $e, $stackTrace");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => GetMaterialApp(
        title: 'Ibadahku',
        theme: ThemeData(
          primarySwatch: Utils.kPrimaryMaterialColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Utils.kPrimaryColor),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          fontFamily: 'PlusJakartaSans',
        ),
        initialRoute: Routes.home,
        getPages: Pages.all,
      ),
    );
  }
}
