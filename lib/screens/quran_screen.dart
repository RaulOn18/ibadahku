import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/controllers/quran_controller.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuranController quranController = Get.put(QuranController());
    if (quranController.allSurah.isEmpty) quranController.fetchAllSurah();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Al-Quran"),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.arrow_left_1,
              size: 28, color: Color(0xff13a795)),
          onPressed: () => Get.back(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Surah'),
            Tab(text: 'Page'),
            Tab(text: 'Juz'),
            // Tab(text: 'Hizb'),
            // Tab(text: 'Ruku'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Last Read section remains the same
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Last Read",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 65,
            child: ListView.separated(
              itemCount: 5,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff13a795),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Al-Kahf",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Ayat 12",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSurahTab(quranController),
                _buildPageTab(),
                _buildJuzTab(),
                // _buildHizbTab(),
                // _buildRukuTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahTab(QuranController quranController) {
    return Obx(
      () {
        if (quranController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            var surah = quranController.allSurah[index];
            return ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/shape_ayat.svg",
                    fit: BoxFit.contain,
                    height: 44,
                  ),
                  Text(
                    "${surah['number']}",
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              title: Text(
                "${surah['name_id']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "${surah['number_of_verses']} Ayat | ${surah['revelation_id']}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff13a795),
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                "${surah['name_short']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff13a795),
                ),
              ),
              onTap: () {
                Get.toNamed(Routes.quranDetail, arguments: {
                  'numberSurah': surah['number'],
                  'title': surah['name_id'],
                  'from': 1,
                  'to': surah['number_of_verses'],
                });
              },
            );
          },
          itemCount: quranController.allSurah.length,
        );
      },
    );
  }

  Widget _buildPageTab() {
    return ListView.builder(
      itemBuilder: (context, index) {
        index++;
        return ListTile(
          leading: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/shape_ayat.svg",
                fit: BoxFit.contain,
                height: 44,
              ),
              Text(
                "$index",
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          title: Text(
            "Halaman $index",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            // Handle page tap
          },
        );
      },
      itemCount: 604,
    );
  }

  Widget _buildJuzTab() {
    return ListView.builder(
      itemBuilder: (context, index) {
        index++;
        return ListTile(
          leading: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/shape_ayat.svg",
                fit: BoxFit.contain,
                height: 44,
              ),
              Text(
                "$index",
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          title: Text(
            "Juz $index",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            // Handle juz tap
          },
        );
      },
      itemCount: 30,
    );
  }

  Widget _buildHizbTab() {
    // Implement Hizb tab content
    return Center(child: Text('Hizb Content'));
  }

  Widget _buildRukuTab() {
    // Implement Ruku tab content
    return Center(child: Text('Ruku Content'));
  }
}
