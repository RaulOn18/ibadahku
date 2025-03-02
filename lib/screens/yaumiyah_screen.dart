import 'dart:developer';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/controllers/yaumiyah_controller.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

  final RxDouble sholatWajibPercentage = 0.0.obs;
  final RxDouble sholatSunnahPercentage = 0.0.obs;
  final RxDouble otherIbadahPercentage = 0.0.obs;

  YaumiyahController controller = Get.put(YaumiyahController());

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    controller
        .fetchDailyRecord(
            DateFormat('y-MM-dd').format(controller.selectedDate.value))
        .then((v) {
      calculatePercentages();
    });
  }

  void calculatePercentages() {
    int totalTasks = 0;
    int completedTasks = 0;

    for (var category in controller.yaumiyahList) {
      List<Map<String, dynamic>> ibadahList = category['list_ibadah'];

      for (var ibadah in ibadahList) {
        // Periksa apakah ini hari Jumat
        bool isFriday =
            DateFormat.EEEE().format(controller.selectedDate.value) == 'Friday';

        // Jangan hitung "Membaca Surat Al-Kahfi" kecuali di hari Jumat
        if (ibadah['title'] == 'Membaca Surat Al-Kahfi' && !isFriday) {
          continue;
        }
        // Hitung task lainnya
        totalTasks++;
        if (ibadah['value'].value == true) {
          completedTasks++;
        }
      }
    }

    // Kalkulasi persentase ibadah yang sudah diselesaikan
    double percentage = 0;

    if (totalTasks > 0) {
      // Hitung persentase dengan akurasi tinggi
      percentage = (completedTasks / totalTasks) * 100;

      // Pastikan persentase dibulatkan hingga 2 angka desimal untuk akurasi
      percentage = percentage.toPrecision(2);

      // Jika semua task sudah selesai, pastikan persentasenya 100%
      if (completedTasks == totalTasks) {
        percentage = 100;
      }
    }

    // Simpan persentase ini untuk dipakai di radial gauge
    log("Percentage: $percentage, completedTasks: $completedTasks, totalTasks: $totalTasks");
    controller.overallPercentage.value = percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildHeader(controller),
          _buildDraggableScrollableSheet(controller),
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

  Widget _buildHeader(YaumiyahController controller) {
    return Container(
      color: Utils.kPrimaryColor,
      child: Column(
        children: [
          _buildDateHeader(controller),
          const SizedBox(height: 12),
          _buildDateTimeline(controller),
          const SizedBox(height: 20),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: SizedBox(
              height: 164,
              child: Obx(
                () => SfRadialGauge(
                  axes: [
                    RadialAxis(
                      minimum: 0,
                      maximum:
                          100, // Karena kita bekerja dengan persentase (0-100)
                      pointers: [
                        RangePointer(
                          value: controller
                              .overallPercentage.value, // Nilai persentase
                          cornerStyle: CornerStyle.bothCurve,
                          color: Utils.kPrimaryColor, // Warna bar
                          width: 24,
                          enableAnimation: true,
                          animationDuration: 1000,
                          animationType: AnimationType.linear,
                        ),
                      ],
                      axisLineStyle: const AxisLineStyle(thickness: 24),
                      showLabels: false,
                      showTicks: false,
                      annotations: [
                        GaugeAnnotation(
                          angle: 90,
                          widget: Obx(
                            () => Text(
                              "${controller.overallPercentage.value.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateHeader(YaumiyahController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Text(
                DateFormat.yMMMMEEEEd('id')
                    .format(controller.selectedDate.value),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
          IconButton(
              icon: const Icon(Icons.restore, color: Colors.white),
              onPressed: () async {
                controller.selectedDate.value = DateTime.now();
                _easyInfiniteDateTimelineController
                    .animateToDate(DateTime.now());

                await controller
                    .fetchDailyRecord(DateFormat('y-MM-dd')
                        .format(controller.selectedDate.value))
                    .then((v) {
                  calculatePercentages();
                });
              }),
        ],
      ),
    );
  }

  Widget _buildDateTimeline(YaumiyahController controller) {
    return Obx(
      () => EasyInfiniteDateTimeLine(
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        focusDate: controller.selectedDate.value,
        locale: "id",
        showTimelineHeader: false,
        dayProps: _getDateTimelineDayProps(),
        controller: _easyInfiniteDateTimelineController,
        lastDate: DateTime.now().add(const Duration(days: 30)),
        onDateChange: (value) async {
          controller.selectedDate.value = value;
          await controller
              .fetchDailyRecord(DateFormat('y-MM-dd').format(value))
              .then((v) {
            calculatePercentages();
          });
          log("selected date: ${controller.selectedDate.value} ${DateFormat.EEEE().format(controller.selectedDate.value)}");
        },
      ),
    );
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

  Widget _buildDraggableScrollableSheet(YaumiyahController controller) {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      minChildSize: Get.height > 800 ? 0.55 : 0.50,
      initialChildSize: Get.height > 800 ? 0.55 : 0.50,
      maxChildSize: 0.91,
      snapSizes: [Get.height > 800 ? 0.55 : 0.50, 0.91],
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
              Obx(
                () => SliverList.builder(
                  itemCount: controller.yaumiyahList.length,
                  itemBuilder: (context, index) {
                    var item = controller.yaumiyahList[index];
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
                        _buildYaumiyahList(item['id'], item['list_ibadah'],
                            item['color'], controller),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildYaumiyahList(
    String amalanTypeId,
    List<Map<String, dynamic>> ibadahList,
    Color? backgroundColor,
    YaumiyahController controller,
  ) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: ibadahList.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      itemBuilder: (context, index) {
        final ibadah = ibadahList[index];
        if (ibadah['title'] == 'Membaca Surat Al-Kahfi' &&
            DateFormat.EEEE().format(controller.selectedDate.value) !=
                'Friday') {
          return Container();
        }
        return Material(
          type: MaterialType.transparency,
          child: Obx(
            () => CheckboxListTile(
              title: Text(ibadah['title']),
              tileColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onChanged: (value) {
                ibadah['value'].value = value;
                _showIbadahSnackBar(ibadah['title']);
                calculatePercentages();
                controller.insertDailyRecord(
                    amalanTypeId, ibadah['id'], ibadah['value'].value);
              },
              controlAffinity: ListTileControlAffinity.platform,
              value: ibadah['value'].value,
              // onTap: () {
              //   _showIbadahSnackBar(ibadah['title']);
              // },
              // trailing: const Icon(Icons.check, color: Utils.kPrimaryColor),
              // leading: Icon(ibadah['icon']),
            ),
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
}
