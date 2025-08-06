import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/controllers/mutabaah_controller.dart';
import 'package:ibadahku/utils/utils.dart';

class MutabaahNotificationSetting extends StatelessWidget {
  const MutabaahNotificationSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final MutabaahController controller = Get.find<MutabaahController>();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Utils.kPrimaryColor,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Pengingat Mutabaah Yaumiyah',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Dapatkan pengingat harian untuk mengisi Mutabaah Yaumiyah setiap hari jam 19:30',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aktifkan Pengingat',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(() => Switch(
                      value: controller.isNotificationEnabled.value,
                      onChanged: controller.toggleNotification,
                      activeColor: Utils.kPrimaryColor,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.testNotification,
                icon: const Icon(Icons.notifications),
                label: const Text('Test Notifikasi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Utils.kPrimaryColor,
                  side: const BorderSide(color: Utils.kPrimaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
