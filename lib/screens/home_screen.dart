import 'dart:async';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/controllers/home_controller.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient client = Supabase.instance.client;
  final DateTime _currentDate = DateTime.now();
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();
  final HomeController _homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupTimer();
  }

  void _initializeData() {
    if (_homeController.currentHijrDate.value.isEmpty) {
      _homeController.requestDataHijrCalendar();
    }
    if (_homeController.allCity.isEmpty) {
      _homeController.requestAllDataCity();
    }
    if (_homeController.prayerTime.isEmpty) {
      _homeController.requestDataPrayerTime(
          _homeController.currentCityId.value, _currentDate);
    }
  }

  void _setupTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.second == 0) {
        // Check when the second changes to 0 (minute change)
        if (_homeController.currentCityId.value != "" &&
            _homeController.currentCity.value != "") {
          log("Minute changed, requesting prayer time at ${DateTime.now()}");

          _homeController.currentPrayerTime.value = "--:--";
          _homeController.currentPrayerTimeName.value = "-";
          _homeController.requestDataPrayerTime(
            _homeController.currentCityId.value,
            DateTime.now(),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _homeController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: _buildAppBar(),
              backgroundColor: Utils.kSecondaryColor,
              body: Stack(
                children: [
                  _buildHeader(),
                  _buildDraggableScrollableSheet(),
                ],
              ),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 72,
      backgroundColor: Utils.kPrimaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      titleTextStyle:
          const TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans'),
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Obx(() => _buildAppBarContent()),
      ),
      actions: [_buildProfileButton()],
    );
  }

  Widget _buildAppBarContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildHijriDate(),
        const SizedBox(height: 4),
        _buildLocationSelector(),
      ],
    );
  }

  Widget _buildHijriDate() {
    return Text(
      _homeController.currentHijrDate.value.isNotEmpty
          ? _homeController.currentHijrDate.value
          : "0 - 0000 H",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _showLocationBottomSheet,
        child: Ink(
          decoration: const BoxDecoration(color: Color(0xff159687)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Obx(() => _buildLocationContent()),
        ),
      ),
    );
  }

  Widget _buildLocationContent() {
    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Icon(
          IconsaxPlusLinear.location,
          color: Colors.white,
          size: 16,
        ),
        Text(
          _homeController.currentCity.value.isNotEmpty
              ? _homeController.currentCity.value.toString().capitalize!
              : "Select Location",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildProfileButton() {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: const Icon(
          IconsaxPlusLinear.user,
          color: Utils.kPrimaryColor,
        ),
        tooltip: 'Profile',
        onPressed: () {
          if (client.auth.currentUser != null) {
            Get.toNamed(Routes.profile);
          } else {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(const SnackBar(
                content: Text("Please login first"),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ));
            Get.toNamed(Routes.login);
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      width: double.infinity,
      height: Get.height > 800 ? 264 : 242,
      decoration: const BoxDecoration(
        color: Utils.kPrimaryColor,
        image: DecorationImage(
          image: AssetImage("assets/images/mosque-bg.png"),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Obx(() => _buildHeaderContent()),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${_homeController.currentPrayerTime}",
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          _homeController.timeAhead.value,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 20),
        _buildPrayerTimes(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildPrayerTimes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPrayerTimeColumn("Fajr", IconsaxPlusBold.sun_fog,
            _homeController.prayerTime['subuh']),
        _buildPrayerTimeColumn("Dzuhur", IconsaxPlusBold.sun_1,
            _homeController.prayerTime['dzuhur']),
        _buildPrayerTimeColumn("Ashar", IconsaxPlusBold.sun_fog,
            _homeController.prayerTime['ashar']),
        _buildPrayerTimeColumn("Maghrib", IconsaxPlusBold.sun_fog,
            _homeController.prayerTime['maghrib']),
        _buildPrayerTimeColumn(
            "Isya", IconsaxPlusBold.moon, _homeController.prayerTime['isya']),
      ],
    );
  }

  Widget _buildPrayerTimeColumn(String title, IconData icon, String? time) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        Icon(icon, size: 32, color: Colors.white),
        Text(time ?? "-", style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildDraggableScrollableSheet() {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      minChildSize: 0.64,
      initialChildSize: 0.64,
      maxChildSize: 0.99,
      snapSizes: const [0.64, 0.99],
      snapAnimationDuration: const Duration(milliseconds: 200),
      snap: true,
      expand: true,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildFeatures(),
                  _buildLatestNews(),
                  _buildAllNews(),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "All Features",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureButton("Quran", IconsaxPlusBold.book_1,
                  () => Get.toNamed(Routes.quran)),
              _buildFeatureButton(
                  "Adzan",
                  IconsaxPlusBold.volume_high,
                  () => ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Coming Soon"),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                      ),
                    ) //Get.toNamed(Routes.adzan)
                  ),
              _buildFeatureButton("Yaumiyah", IconsaxPlusBold.note, () {
                if (client.auth.currentUser != null) {
                  Get.toNamed(Routes.yaumiyah);
                } else {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Please login first"),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                      ),
                    );
                  Get.toNamed(Routes.login);
                }
              }),
              _buildFeatureButton(
                "Dzikr",
                IconsaxPlusBold.archive_book,
                () => ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Coming Soon"),
                      behavior: SnackBarBehavior.floating,
                      showCloseIcon: true,
                    ),
                  ) //Get.toNamed(Routes.dizkr)
                ,
              ),
              _buildFeatureButton("More", IconsaxPlusBold.menu, () {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Coming Soon"),
                      behavior: SnackBarBehavior.floating,
                      showCloseIcon: true,
                    ),
                  );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureButton(String title, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: Get.width / 5 - 14,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            InkWell(
              onTap: () => onTap(),
              child: Ink(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Utils.kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestNews() {
    List<String> newsImages = [
      "assets/images/17.jpg",
      "assets/images/17-1.jpg",
      "assets/images/pmb.jpg",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            "Latest News",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: newsImages.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: Get.width,
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    i,
                    fit: BoxFit.fill,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAllNews() {
    List<String> newsImages = [
      "assets/images/17.jpg",
      "assets/images/17-1.jpg",
      "assets/images/pmb.jpg",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            "All News",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
          itemCount: newsImages.length,
          itemBuilder: (context, index) {
            return _buildNewsCard(newsImages[index]);
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard(String image) {
    return Container(
      height: 130,
      width: 160,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 130,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Image.asset(image, fit: BoxFit.fill),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Lorem ipsum dolor sit amet, lorem ipsum dolort sit amet",
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text("Baca lebih lanjut..")],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.9,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      anchorPoint: const Offset(0, 0),
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Obx(
          () => SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                _buildSearchLocationBar(),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _homeController.allCity.length,
                    itemBuilder: (context, index) {
                      var city = _homeController.allCity[index];
                      return _buildCityListTile(city);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((v) {
      _homeController.searchController.clear();
      _homeController.requestAllDataCity();
    });
  }

  Widget _buildSearchLocationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _homeController.searchController,
        onChanged: (v) {
          debugPrint("search city: $v");
          _homeController.searchCity(v);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: "Search location",
          prefixIcon: const Icon(IconsaxPlusLinear.search_normal),
        ),
      ),
    );
  }

  Widget _buildCityListTile(Map<String, dynamic> city) {
    return ListTile(
      enableFeedback: true,
      iconColor: Utils.kPrimaryColor,
      onTap: () {
        _homeController.changeCurrentLocation(city['lokasi'], city['id']);
        Get.back();
      },
      leading: const Icon(IconsaxPlusLinear.location),
      title: Text("${city["lokasi"]}".capitalize!),
    );
  }
}
