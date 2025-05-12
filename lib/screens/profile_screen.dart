import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/controllers/user_controller.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SupabaseClient client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    if (userController.user == null) {
      userController.fetchUser();
    }

    // Sample data untuk progress harian (data ini bisa diambil dari controller)
    List<double> dailyProgress = [
      60,
      70,
      80,
      75,
      90,
      95,
      100
    ]; // Persentase tiap hari (misalnya 7 hari terakhir)

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Utils.kPrimaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            IconsaxPlusLinear.arrow_left_1,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Utils.kPrimaryColor,
      body: Obx(
        () => userController.isFetchingUser.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                children: [
                  Container(
                    color: Utils.kPrimaryColor,
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            child: userController.user == null
                                ? const Icon(IconsaxPlusLinear.user, size: 32)
                                : Image.network(
                                    userController.user!.photoProfile ?? "",
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child,
                                            loadingProgress) =>
                                        (loadingProgress == null)
                                            ? child
                                            : const CircularProgressIndicator(),
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        IconsaxPlusLinear.user,
                                        size: 32,
                                      );
                                    },
                                    width: 64,
                                    height: 64,
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userController.user?.name ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const Text(
                            "Account Overview",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Material(
                            type: MaterialType.transparency,
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  IconsaxPlusLinear.user,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                // Get.toNamed(Routes.);
                              },
                            ),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  IconsaxPlusLinear.document_download,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                "Export Data",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                // Get.toNamed(Routes.);
                              },
                            ),
                          ),
                          Material(
                            type: MaterialType.transparency,
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  IconsaxPlusLinear.logout_1,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                "Logout Account",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                userController.logout();
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Progress Harian",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height: 300,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: true),
                                titlesData: const FlTitlesData(show: true),
                                borderData: FlBorderData(
                                  show: true,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: dailyProgress
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(e.key.toDouble(),
                                            e.value.toDouble()))
                                        .toList(),
                                    isCurved: true,
                                    barWidth: 4,
                                    color: Colors.blue,
                                    // colors: [Colors.blue],
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.blue.withValues(alpha: 0.3),
                                      // colors: [
                                      //   Colors.blue.withOpacity(0.3),
                                      // ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
