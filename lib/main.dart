import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/services/notification_service.dart';
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

  // Initialize Firebase with error handling
  // try {
  //   await Firebase.initializeApp();
  //   log("Firebase initialized successfully");
  // } catch (e) {
  //   log("Firebase initialization failed: $e");
  //   log("Continuing without Firebase features...");
  // }

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: notificationTapForeground);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await GetStorage.init();
  initializeDateFormatting('id_ID', null);

  // Initialize NotificationService
  Get.put(NotificationService());

  try {
    await Supabase.initialize(
        url: "https://bpclthqlkjnmyokrhzsh.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJwY2x0aHFsa2pubXlva3JoenNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQyODc0ODUsImV4cCI6MjAzOTg2MzQ4NX0.2n1zWv85IIdhqjeHyBvU1lp1ZoDopePRFuh4KVf1pAY");
  } catch (e, stackTrace) {
    log("Error initializing supabase: $e, $stackTrace");
  }
  // Only setup Firebase services if Firebase was initialized successfully
  // try {
  //   if (Firebase.apps.isNotEmpty) {
  //     saveFCMToken();

  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       log('Got a message whilst in the background!');
  //     });

  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //       log('Got a message opened app!');
  //     });
  //   } else {
  //     log('Firebase not initialized, skipping FCM setup');
  //   }
  // } catch (e) {
  //   log('Error setting up Firebase services: $e');
  // }

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  _handleNotificationTap(notificationResponse);
}

@pragma('vm:entry-point')
void notificationTapForeground(NotificationResponse notificationResponse) {
  _handleNotificationTap(notificationResponse);
}

void _handleNotificationTap(NotificationResponse notificationResponse) {
  log('Notification tapped: ${notificationResponse.payload}');

  if (notificationResponse.payload == 'mutabaah_reminder') {
    // Navigate to Mutabaah Yaumiyah page
    Get.toNamed(Routes.yaumiyah);
  }
}

// Future<void> saveFCMToken() async {
//   try {
//     // Check if Firebase is available
//     if (Firebase.apps.isEmpty) {
//       log('Firebase not initialized, skipping FCM token setup');
//       return;
//     }

//     final supabase = Supabase.instance.client;
//     final messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       String? token = await messaging.getToken();
//       final userId = supabase.auth.currentUser?.id;

//       if (token != null && userId != null) {
//         await supabase.from("user_fcm_token").upsert({
//           "token": token,
//           "user_id": userId,
//         });
//         log('FCM token saved successfully');
//       }
//     }

//     // listen auth state change
//     supabase.auth.onAuthStateChange.listen((data) async {
//       if (data.event == AuthChangeEvent.signedIn) {
//         await saveFCMToken();
//       }
//     });
//   } catch (e) {
//     log('Error in saveFCMToken:');
//   }
// }

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
