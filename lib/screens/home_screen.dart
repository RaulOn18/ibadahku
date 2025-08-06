import 'dart:async';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibadahku/components/custom_badge.dart';
import 'package:ibadahku/components/custom_button.dart';
import 'package:ibadahku/components/custom_title_header_home.dart';
import 'package:ibadahku/constants/box_storage.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/controllers/announcement_controller.dart';
import 'package:ibadahku/controllers/home_controller.dart';
import 'package:ibadahku/core/services/log_service.dart';
import 'package:ibadahku/screens/event/controllers/event_controller.dart';
import 'package:ibadahku/screens/scan_qr/views/scan_qr_view.dart';
import 'package:ibadahku/screens/announcement/views/announcement_list_view.dart';
import 'package:ibadahku/screens/announcement/views/announcement_detail_view.dart';
import 'package:ibadahku/screens/survey/views/survey_info_view.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
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
  final AnnouncementController _announcementController =
      Get.put(AnnouncementController());
  final EventController _eventController = Get.put(EventController());

  final GlobalKey _scanQRKey = GlobalKey();
  final GlobalKey _yaumiyahKey = GlobalKey();
  final GlobalKey _newsKey = GlobalKey();
  final GlobalKey _eventKey = GlobalKey();
  final GlobalKey _prayerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _setupTimer();
        _initializeData();
        if (!kIsWeb) {
          _homeController.checkUpdate(isShowNotUpdateAvailable: false);
        }
        final isShow = await BoxStorage().get("showcase_home");
        if (isShow != true) {
          debugPrint("Showcase home before $isShow");
          await BoxStorage().save("showcase_home", true);
          debugPrint("Showcase home after $isShow");

          ShowCaseWidget.of(Get.context!).startShowCase([
            _scanQRKey,
            _yaumiyahKey,
            _newsKey,
            _prayerKey,
            // _eventKey,
          ]);
        }
      });
    }
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

    if (client.auth.currentUser != null) {
      _announcementController.fetchAnnouncement();
      _eventController.fetchEventForCurrentUser();
      _eventController.fetchActiveEvent();
      _checkIsUsersHasSubmittedSurveys();
    }
  }

  void _setupTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.second == 0) {
        // Check when the second changes to 0 (minute change)
        if (_homeController.currentCityId.value != "" &&
            _homeController.currentCity.value != "") {
          LogService.t(
              "Minute changed, requesting prayer time at ${DateTime.now()}");

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

  Future<void> _checkIsUsersHasSubmittedSurveys() async {
    try {
      final activeSurveyId = await client.rpc('get_active_survey_id');

      if (activeSurveyId == null) {
        return;
      }

      log("Active survey id: $activeSurveyId");

      final response = await client.rpc("has_user_submitted_survey", params: {
        'p_survey_id': activeSurveyId,
        'p_user_id': client.auth.currentUser!.id
      }) as bool;

      if (response == false) {
        log("User has not submitted survey");
        showModalBottomSheet(
          useSafeArea: true,
          isDismissible: false,
          showDragHandle: true,
          enableDrag: false,
          context: Get.context!,
          backgroundColor: Utils.kWhiteColor,
          builder: (context) => SurveyInfoView(
            surveyId: activeSurveyId.toString(),
          ),
        );
      }
    } catch (e, stackTrace) {
      log("Error: when check survey $e $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Utils.kSecondaryColor,
      body: Stack(
        children: [
          _buildHeader(context),
          _buildDraggableScrollableSheet(),
        ],
      ),
      floatingActionButton: Showcase(
        key: _scanQRKey,
        title: "Scan QR Code Event",
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        description: "Scan QR Code Event untuk absen acara",
        descTextStyle: const TextStyle(
          fontSize: 14,
        ),
        descriptionTextAlign: TextAlign.center,
        child: FloatingActionButton(
          onPressed: () {
            if (client.auth.currentUser == null) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(const SnackBar(
                  content: Text("Please login first"),
                  behavior: SnackBarBehavior.floating,
                  showCloseIcon: true,
                ));
              Get.toNamed(Routes.login)?.then((_) => {
                    if (client.auth.currentUser != null)
                      {
                        Get.to(() => const ScanQrScreen(),
                                arguments: ScanQrArgs(
                                    title: "", description: "", qrValue: ""))
                            ?.then((_) {
                          _initializeData();
                        }),
                      }
                  });
              return;
            }
            Get.to(() => const ScanQrScreen(),
                arguments: ScanQrArgs(title: "", description: "", qrValue: ""));
          },
          backgroundColor: Utils.kSecondaryColor,
          foregroundColor: Utils.kWhiteColor,
          child: const Icon(IconsaxPlusBold.scan_barcode),
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
          decoration: const BoxDecoration(color: Utils.kSecondaryColor),
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
            Get.toNamed(Routes.login)?.then((_) {
              if (client.auth.currentUser != null) {
                Get.toNamed(Routes.profile)?.then((_) {
                  _initializeData();
                });
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      alignment: Alignment.center, // Mungkin tidak diperlukan lagi dengan Stack
      padding: EdgeInsets.zero,
      width: context.width,
      height: Get.height > 800 ? 264 : 242,
      decoration: const BoxDecoration(
        color: Utils.kPrimaryColor, // Warna latar belakang utama
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/svg/mosque-bg-purple.svg",
              color: Utils.kSecondaryColor,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Align(
            alignment: Alignment.center, // Atur posisi konten header
            child: Obx(() => _buildHeaderContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Showcase(
          key: _prayerKey,
          title: "Waktu Sholat",
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          description: "Waktu sholat berdasarkan lokasi Anda",
          descTextStyle: const TextStyle(
            fontSize: 14,
          ),
          descriptionTextAlign: TextAlign.center,
          child: Text(
            "${_homeController.currentPrayerTime}",
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
          // Pull to refresh
          child: RefreshIndicator(
            onRefresh: () async {
              // fetch data event and news
              _initializeData();
              // init again
            },
            child: CustomScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  snap: true,
                  surfaceTintColor: Utils.kWhiteColor,
                  backgroundColor: Utils.kWhiteColor,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  primary: false,
                  centerTitle: true,
                  toolbarHeight: 40,
                  titleSpacing: 0.0,
                  title: FutureBuilder(
                    future: Utils.getAppVersion(),
                    builder: (context, snapshot) => Text(
                      "v${snapshot.data ?? '-'}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildFeatures(),
                    _buildOngoingEvent(),
                    _buildLatestNews(),
                    _buildUpcomingEvent(),
                    const SizedBox(height: 64),
                  ]),
                ),
              ],
            ),
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
          padding: EdgeInsets.only(left: 20),
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
                  () => Get.toNamed(Routes.quran), context),
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
                ,
                context,
              ),
              Showcase(
                key: _yaumiyahKey,
                title: "Yaumiyah",
                description: "Yaumiyah fitur untuk mengelola ibadah harian",
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                descTextStyle: const TextStyle(
                  fontSize: 14,
                ),
                descriptionTextAlign: TextAlign.center,
                child: _buildFeatureButton(
                  "Yaumiyah",
                  IconsaxPlusBold.note,
                  () {
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
                      Get.toNamed(Routes.login)?.then(
                        (_) => {
                          if (client.auth.currentUser != null)
                            {
                              Get.toNamed(Routes.yaumiyah)?.then((_) {
                                log("BACK FROM YAUMIYAH");
                                _initializeData();
                              }),
                            }
                        },
                      );
                    }
                  },
                  context,
                ),
              ),
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
                  context),
              _buildFeatureButton(
                "More",
                IconsaxPlusBold.menu,
                () {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Coming Soon"),
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                      ),
                    );
                },
                context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureButton(
      String title, IconData icon, VoidCallback onTap, BuildContext context) {
    return Material(
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
                color: Utils.kSecondaryColor,
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
    );
  }

  Widget _buildOngoingEvent() {
    return Obx(
      () => Get.put(EventController()).activeEventList.isEmpty
          ? const SizedBox.shrink()
          : Card(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              color: Utils.kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                child: Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Utils.kWhiteColor,
                          borderRadius: BorderRadius.circular(100)),
                      width: 40,
                      height: 40,
                      child: Icon(
                        Get.put(EventController())
                                .activeEventList
                                .first
                                .isAttended
                            ? IconsaxPlusBold.notification
                            : IconsaxPlusBold.notification,
                        color: Utils.kPrimaryColor,
                        size: 20,
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kajian Rutin Al-Hikam",
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Masjid Daarut Tauhid",
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 64,
                      child: CustomButton(
                        backgroundColor: Utils.kWhiteColor,
                        textColor: Utils.kPrimaryColor,
                        onTap: () {},
                        height: 32,
                        fontSize: 12,
                        isLoading: false,
                        text: "Absen",
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUpcomingEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Showcase(
          key: _eventKey,
          title: "Acara Mendatang",
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          description: "Acara mendatang dari manajemen STAI Daarut Tauhid",
          descTextStyle: const TextStyle(
            fontSize: 14,
          ),
          descriptionTextAlign: TextAlign.center,
          child: CustomTitleHeaderHome(
            title: "Acara Mendatang",
            trailing: InkWell(
              onTap: () {
                if (client.auth.currentUser == null) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(const SnackBar(
                      content: Text("Please login first"),
                      behavior: SnackBarBehavior.floating,
                      showCloseIcon: true,
                    ));
                  Get.toNamed(Routes.login)?.then((v) {
                    if (client.auth.currentUser != null) {
                      Get.toNamed(Routes.event)?.then((_) {
                        _initializeData();
                      });
                    }
                  });
                  return;
                } else {
                  Get.toNamed(Routes.event);
                }
              },
              child: const Text(
                "Lihat Semua",
                style: TextStyle(
                  color: Utils.kPrimaryColor,
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => _eventController.eventList
                  .where((element) => element.status == "upcoming")
                  .isEmpty
              ? Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  elevation: 0,
                  color: Utils.kWhiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Utils.kGreyColor, width: 0.5)),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: const Column(
                      children: [
                        Icon(
                          IconsaxPlusBold.notification_status,
                          size: 32,
                          color: Utils.kPrimaryColor,
                        ),
                        Text("Tidak ada acara"),
                      ],
                    ),
                  ))
              : ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  padding: const EdgeInsets.only(top: 12),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // max 3 item
                  itemCount: _eventController.eventList
                              .where((element) => element.status == "upcoming")
                              .length >
                          3
                      ? 3
                      : _eventController.eventList
                          .where((element) => element.status == "upcoming")
                          .length,
                  itemBuilder: (context, index) {
                    var event = _eventController.eventList
                        .where((element) => element.status == "upcoming")
                        .elementAt(index);
                    return Card(
                      key: ValueKey(event.id),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      elevation: 0,
                      color: Utils.kWhiteColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              BorderSide(color: Utils.kGreyColor, width: 0.5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) => Column(
                                  spacing: 6,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      spacing: 4,
                                      children: [
                                        const Icon(
                                          IconsaxPlusLinear.clock_1,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth - 40,
                                          child: Text.rich(
                                            TextSpan(
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 12,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${event.startTime.hour}:${event.startTime.minute} - ${event.endTime.hour}:${event.endTime.minute}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: " • ",
                                                ),
                                                TextSpan(
                                                  text: DateFormat(
                                                          "dd MMMM", "id")
                                                      .format(event.startTime),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          IconsaxPlusLinear.location,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          event.locationName,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            CustomBadge(
                              text: event.isAttended
                                  ? "Sudah Absen"
                                  : "Belum Absen",
                              color: event.isAttended
                                  ? Colors.green
                                  : Utils.kPrimaryColor,
                              backgroundColor: event.isAttended
                                  ? Colors.green
                                  : Utils.kPrimaryColor,
                              surfaceColor: Colors.white,
                              isShowDot: false,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }

  Widget _buildNetworkImage(String imageUrl, {double? width, double? height}) {
    // Handle empty or null URLs
    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Utils.kPrimaryColor.withValues(alpha: 0.1),
        child: const Icon(
          Icons.announcement_outlined,
          color: Utils.kPrimaryColor,
          size: 32,
        ),
      );
    }

    // For web, use CORS proxy to avoid CORS issues
    String finalImageUrl = imageUrl;
    if (kIsWeb) {
      // Use a CORS proxy service for web
      finalImageUrl =
          'https://api.allorigins.win/raw?url=${Uri.encodeComponent(imageUrl)}';
    }

    return Image.network(
      finalImageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: Utils.kPrimaryColor,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Utils.kPrimaryColor.withValues(alpha: 0.1),
          child: const Icon(
            Icons.announcement_outlined,
            color: Utils.kPrimaryColor,
            size: 32,
          ),
        );
      },
    );
  }

  Widget _buildLatestNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Showcase(
          key: _newsKey,
          title: "Berita Terbaru",
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          description: "Berita terbaru dari manajemen STAI Daarut Tauhid",
          descTextStyle: const TextStyle(
            fontSize: 14,
          ),
          descriptionTextAlign: TextAlign.center,
          child: CustomTitleHeaderHome(
            title: "Pengumuman",
            trailing: InkWell(
              onTap: () {
                Get.to(() => const AnnouncementListView());
              },
              child: const Text(
                "Lihat Semua",
                style: TextStyle(
                  color: Utils.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => _announcementController.announcementList.isEmpty
              ? const Center(child: Text("Tidak ada berita"))
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ),
                  items: _announcementController.announcementList.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                                () => AnnouncementDetailView(announcement: i));
                          },
                          child: Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(12),
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color:
                                  Utils.kPrimaryColor.withValues(alpha: 0.15),
                              border: const Border(),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: _buildNetworkImage(
                                      i!.imageUrl ?? "",
                                      width: Get.width,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        i.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${i.content.split(" ").take(6).join(" ")}...",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
        ),
      ],
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
