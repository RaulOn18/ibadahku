import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class YaumiyahScreen extends StatefulWidget {
  const YaumiyahScreen({super.key});

  @override
  State<YaumiyahScreen> createState() => _YaumiyahScreenState();
}

class _YaumiyahScreenState extends State<YaumiyahScreen> {
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();
  final EasyInfiniteDateTimelineController _easyInfiniteDateTimelineController =
      EasyInfiniteDateTimelineController();
  final Rx<DateTime> _selectedDate = DateTime.now().obs;

  final List<Map<String, dynamic>> yaumiyahList = [
    {
      "title": "Cinta Sholat",
      "color": Colors.cyan[50],
      "icon": IconsaxPlusLinear.calendar,
      "list_ibadah": [
        {"title": "Sholat Subuh", "icon": IconsaxPlusLinear.clock},
        {"title": "Sholat Dzuhur", "icon": IconsaxPlusLinear.clock},
        {"title": "Sholat Ashar", "icon": IconsaxPlusLinear.clock},
        {"title": "Sholat Maghrib", "icon": IconsaxPlusLinear.clock},
        {"title": "Sholat Isya", "icon": IconsaxPlusLinear.clock},
      ]
    },
    {
      "title": "Cinta Qur'an",
      "color": Colors.green[50],
      "icon": IconsaxPlusLinear.book_1,
      "list_ibadah": [
        {"title": "Membaca Al-Qur'an", "icon": IconsaxPlusLinear.book_1},
        {
          "title": "Menghafal Al-Qur'an",
          "icon": IconsaxPlusLinear.battery_charging
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildHeader(),
          _buildDraggableScrollableSheet(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Yaumiyah"),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: Get.back,
        icon: const Icon(IconsaxPlusLinear.arrow_left_1),
      ),
      backgroundColor: Utils.kPrimaryColor,
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Utils.kPrimaryColor,
      child: Column(
        children: [
          _buildDateHeader(),
          const SizedBox(height: 12),
          _buildDateTimeline(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Text(
                DateFormat.yMMMMEEEEd('id').format(_selectedDate.value),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
          IconButton(
            icon: const Icon(Icons.restore, color: Colors.white),
            onPressed: _resetToCurrentDate,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeline() {
    return Obx(() => EasyInfiniteDateTimeLine(
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          focusDate: _selectedDate.value,
          locale: "id",
          showTimelineHeader: false,
          dayProps: _getDateTimelineDayProps(),
          controller: _easyInfiniteDateTimelineController,
          lastDate: DateTime.now().add(const Duration(days: 30)),
          onDateChange: (value) => _selectedDate.value = value,
        ));
  }

  EasyDayProps _getDateTimelineDayProps() {
    return EasyDayProps(
      dayStructure: DayStructure.dayStrDayNum,
      landScapeMode: false,
      height: 64,
      width: 50,
      borderColor: Colors.transparent,
      todayStyle: DayStyle(
        dayNumStyle: const TextStyle(color: Colors.white),
        dayStrStyle: const TextStyle(color: Colors.white),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      activeDayStyle: DayStyle(
        dayNumStyle: const TextStyle(color: Colors.black),
        dayStrStyle: const TextStyle(color: Colors.black),
        decoration: BoxDecoration(
          color: Utils.kWhiteColor,
          border: Border.all(color: Utils.kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inactiveDayStyle: const DayStyle(
        dayNumStyle: TextStyle(color: Colors.white),
        dayStrStyle: TextStyle(color: Colors.white),
        decoration: BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  Widget _buildDraggableScrollableSheet() {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      minChildSize: 0.75,
      initialChildSize: 0.75,
      maxChildSize: 0.91,
      snapSizes: const [0.75, 0.91],
      snapAnimationDuration: const Duration(milliseconds: 200),
      snap: true,
      expand: true,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverList.builder(
                itemCount: yaumiyahList.length,
                itemBuilder: (context, index) {
                  var item = yaumiyahList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildYaumiyahList(item['list_ibadah'], item['color']),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildYaumiyahList(
      List<Map<String, dynamic>> ibadahList, Color? backgroundColor) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: ibadahList.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      itemBuilder: (context, index) {
        final ibadah = ibadahList[index];
        return Material(
          type: MaterialType.transparency,
          child: ListTile(
            title: Text(ibadah['title']),
            tileColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            onTap: () => _showIbadahSnackBar(ibadah['title']),
            trailing: const Icon(Icons.check, color: Utils.kPrimaryColor),
            leading: Icon(ibadah['icon']),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 14),
    );
  }

  void _showIbadahSnackBar(String ibadahTitle) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text("$ibadahTitle Uploaded"),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _resetToCurrentDate() {
    _selectedDate.value = DateTime.now();
    _easyInfiniteDateTimelineController.animateToDate(DateTime.now());
  }
}
