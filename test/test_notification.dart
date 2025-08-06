// File ini hanya untuk testing - bisa dihapus setelah testing selesai
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/controllers/mutabaah_controller.dart';
import 'package:ibadahku/services/notification_service.dart';

class TestNotificationPage extends StatelessWidget {
  const TestNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MutabaahController controller = Get.put(MutabaahController());
    final NotificationService notificationService =
        Get.find<NotificationService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifikasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test Fitur Notifikasi Mutabaah Yaumiyah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() => SwitchListTile(
                  title: const Text('Aktifkan Notifikasi Harian'),
                  subtitle: const Text('Notifikasi akan muncul jam 19:30'),
                  value: controller.isNotificationEnabled.value,
                  onChanged: controller.toggleNotification,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.testNotification(),
              child: const Text('Test Notifikasi Sekarang'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  notificationService.scheduleDailyMutabaahReminder(),
              child: const Text('Schedule Notifikasi Harian'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => notificationService.cancelDailyReminder(),
              child: const Text('Cancel Notifikasi Harian'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cara Test:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '1. Klik "Test Notifikasi Sekarang" untuk melihat notifikasi\n'
              '2. Aktifkan switch untuk mengaktifkan notifikasi harian\n'
              '3. Notifikasi akan muncul setiap hari jam 19:30\n'
              '4. Klik notifikasi untuk masuk ke halaman Yaumiyah',
            ),
          ],
        ),
      ),
    );
  }
}
