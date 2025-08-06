import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ibadahku/services/notification_service.dart';

class MutabaahController extends GetxController {
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final GetStorage _storage = GetStorage();

  // Observable untuk status notifikasi
  final RxBool isNotificationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotificationSettings();
  }

  void _loadNotificationSettings() {
    // Load saved notification setting, default to true
    final savedSetting = _storage.read('mutabaah_notification_enabled') ?? true;
    isNotificationEnabled.value = savedSetting;

    // If notification was enabled, schedule it
    if (isNotificationEnabled.value) {
      _scheduleNotification();
    }
  }

  Future<void> toggleNotification(bool enabled) async {
    try {
      isNotificationEnabled.value = enabled;
      await _storage.write('mutabaah_notification_enabled', enabled);

      if (enabled) {
        await _notificationService.scheduleDailyMutabaahReminder();
        Get.snackbar(
          'Notifikasi Diaktifkan',
          'Pengingat Mutabaah Yaumiyah akan muncul setiap hari jam 19:30',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await _cancelNotification();
        Get.snackbar(
          'Notifikasi Dinonaktifkan',
          'Pengingat Mutabaah Yaumiyah telah dimatikan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('Error toggling notification: $e');
      // Reset the toggle if scheduling failed
      isNotificationEnabled.value = !enabled;

      if (e.toString().contains('exact_alarms_not_permitted')) {
        Get.snackbar(
          'Permission Diperlukan',
          'Aplikasi memerlukan izin untuk notifikasi tepat waktu. Silakan aktifkan di pengaturan sistem.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengatur notifikasi: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _scheduleNotification() async {
    try {
      await _notificationService.scheduleDailyMutabaahReminder();
      log('Mutabaah notification scheduled');
    } catch (e) {
      log('Failed to schedule notification: $e');
      // Don't show error to user for automatic scheduling
      // Just log it for debugging
    }
  }

  Future<void> _cancelNotification() async {
    await _notificationService.cancelDailyReminder();
    log('Mutabaah notification cancelled');
  }

  Future<void> testNotification() async {
    await _notificationService.showTestNotification();
    Get.snackbar(
      'Test Notifikasi',
      'Notifikasi test telah dikirim',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
