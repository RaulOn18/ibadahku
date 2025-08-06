import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService extends GetxService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    _initializeTimezone();
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permission for notifications
    await _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Request basic notification permission
      await androidImplementation.requestNotificationsPermission();

      // Request exact alarm permission for Android 12+
      try {
        await androidImplementation.requestExactAlarmsPermission();
        log('Exact alarms permission requested');
      } catch (e) {
        log('Exact alarms permission request failed: $e');
      }
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    log('Notification tapped: ${notificationResponse.payload}');

    // Navigate to Mutabaah Yaumiyah page when notification is tapped
    if (notificationResponse.payload == 'mutabaah_reminder') {
      Get.toNamed(Routes.yaumiyah);
    }
  }

  Future<void> scheduleDailyMutabaahReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'mutabaah_reminder',
      'Mutabaah Yaumiyah Reminder',
      channelDescription: 'Daily reminder to fill Mutabaah Yaumiyah',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      // Try exact scheduling first
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0, // notification id
        'Mutabaah Yaumiyah', // title
        'Jangan lupa mengisi Mutabaah Yaumiyah hari ini! 📝', // body
        _nextInstanceOf730PM(),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'mutabaah_reminder',
      );
      log('Daily Mutabaah reminder scheduled for 7:30 PM (exact)');
    } catch (e) {
      log('Exact alarm failed: $e, trying inexact scheduling');
      try {
        // Fallback to inexact scheduling
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          0, // notification id
          'Mutabaah Yaumiyah', // title
          'Jangan lupa mengisi Mutabaah Yaumiyah hari ini! 📝', // body
          _nextInstanceOf730PM(),
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'mutabaah_reminder',
        );
        log('Daily Mutabaah reminder scheduled for 7:30 PM (inexact)');
      } catch (e2) {
        log('Both exact and inexact scheduling failed: $e2');
        // Try simple periodic notification as last resort
        await _schedulePeriodicNotification();
      }
    }
  }

  tz.TZDateTime _nextInstanceOf730PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      19, // 7 PM in 24-hour format
      30, // 30 minutes
    );

    // If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelDailyReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
    log('Daily Mutabaah reminder cancelled');
  }

  Future<void> _schedulePeriodicNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'mutabaah_reminder',
      'Mutabaah Yaumiyah Reminder',
      channelDescription: 'Daily reminder to fill Mutabaah Yaumiyah',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      // Schedule daily notification using zonedSchedule with inexact mode
      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        19, // 7 PM
        30, // 30 minutes
      );

      // If time has passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Mutabaah Yaumiyah',
        'Jangan lupa mengisi Mutabaah Yaumiyah hari ini! 📝',
        scheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'mutabaah_reminder',
      );

      log('Fallback notification scheduled for: $scheduledTime');
    } catch (e) {
      log('Fallback scheduling also failed: $e');
    }
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      999,
      'Test Notification',
      'Jangan lupa mengisi Mutabaah Yaumiyah hari ini! 📝',
      platformChannelSpecifics,
      payload: 'mutabaah_reminder',
    );
  }
}
