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
        // Skip if not visible for current day
        if (!_shouldShowIbadah(ibadah, controller)) {
          continue;
        }

        totalTasks++;

        if (ibadah['input_type'] == 'checkbox') {
          if (ibadah['value'].value == "1") {
            completedTasks++;
          }
        } else {
          // For dropdown, consider it completed if value is not '0'
          if (ibadah['value'].value != "0") {
            completedTasks++;
          }
        }
      }
    }

    double percentage = 0;
    if (totalTasks > 0) {
      percentage = (completedTasks / totalTasks) * 100;
      percentage = percentage.toPrecision(2);
      if (completedTasks == totalTasks) {
        percentage = 100;
      }
    }

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

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      controller.selectedDate.value = pickedDate;
      _easyInfiniteDateTimelineController.animateToDate(pickedDate);
      controller
          .fetchDailyRecord(DateFormat('y-MM-dd').format(pickedDate))
          .then((v) {
        calculatePercentages();
      });
    }
  }

  Widget _buildDateHeader(YaumiyahController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => InkWell(
                onTap: () {
                  _showDatePicker();
                },
                child: Text(
                  DateFormat.yMMMMEEEEd('id')
                      .format(controller.selectedDate.value),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
          const Spacer(),
          // IconButton(
          //   onPressed: () async {
          //     Future<void> handle() async {
          //       for (final dateString in controller.listDateForReport) {
          //         try {
          //           final parsedDate = DateTime.parse(dateString);
          //           final startDate = DateTime(2025, 4, 1);
          //           final endDate = DateTime(2025, 4, 9);

          //           const isFilter = false;

          //           if (isFilter) {
          //             if (parsedDate.isAfter(
          //                     startDate.subtract(const Duration(days: 1))) &&
          //                 parsedDate
          //                     .isBefore(endDate.add(const Duration(days: 1)))) {
          //               // log("Tanggal dalam rentang: $dateString");
          //             } else {
          //               controller.insertDailyRecordsForDate(dateString);
          //               // log("Tanggal di luar rentang: $dateString");
          //             }
          //           } else {
          //             await controller.insertDailyRecordsForDate(dateString);
          //           }
          //         } catch (e) {
          //           log("Format tanggal tidak valid: $dateString - $e");
          //         }
          //       }
          //     }

          //     await handle();
          //     ScaffoldMessenger.of(context)
          //       ..clearSnackBars()
          //       ..showSnackBar(const SnackBar(
          //         content: Text("Berhasil memasukkan data"),
          //       ));
          //   },
          //   icon: const Icon(
          //     IconsaxPlusBold.calendar,
          //     size: 20,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildDateTimeline(YaumiyahController controller) {
    return Obx(
      () => EasyInfiniteDateTimeLine(
        firstDate: DateTime(controller.selectedDate.value.year,
            controller.selectedDate.value.month, 1),
        lastDate: DateTime(controller.selectedDate.value.year,
            controller.selectedDate.value.month + 1, 0),
        focusDate: controller.selectedDate.value,
        locale: "id",
        showTimelineHeader: false,
        dayProps: _getDateTimelineDayProps(),
        controller: _easyInfiniteDateTimelineController,
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

        // Skip certain items based on day
        if (!_shouldShowIbadah(ibadah, controller)) {
          return Container();
        }

        return Material(
          type: MaterialType.transparency,
          child: ibadah['input_type'] == 'checkbox'
              ? _buildCheckboxTile(
                  ibadah, amalanTypeId, backgroundColor, controller)
              : _buildDropdownTile(
                  ibadah, amalanTypeId, backgroundColor, controller),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 14),
    );
  }

  bool _shouldShowIbadah(
      Map<String, dynamic> ibadah, YaumiyahController controller) {
    final currentDay = DateFormat.EEEE().format(controller.selectedDate.value);

    if (ibadah['title'] == 'Membaca Surat Al-Kahfi' && currentDay != 'Friday') {
      return false;
    }
    if (ibadah['title'] == 'Menyimak kajian Marifatullah' &&
        currentDay != 'Thursday') {
      return false;
    }
    if (ibadah['title'] == 'Menyimak kajian Al-Hikam' &&
        currentDay != 'Thursday') {
      return false;
    }

    return true;
  }

  Widget _buildCheckboxTile(
    Map<String, dynamic> ibadah,
    String amalanTypeId,
    Color? backgroundColor,
    YaumiyahController controller,
  ) {
    return Obx(
      () => CheckboxListTile(
        title: Text(ibadah['title']),
        subtitle: ibadah['target_value'] != null
            ? Text('Target: ${ibadah['target_value']}x')
            : null,
        tileColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onChanged: (bool? value) {
          final newValue = value == true ? "1" : "0";
          ibadah['value'].value = newValue;
          _showIbadahSnackBar(ibadah['title']);
          calculatePercentages();
          controller.insertDailyRecord(amalanTypeId, ibadah['id'], newValue);
        },
        controlAffinity: ListTileControlAffinity.platform,
        value: ibadah['value'].value ==
            "1", // Convert string to boolean for checkbox
      ),
    );
  }

  Widget _buildDropdownTile(
    Map<String, dynamic> ibadah,
    String amalanTypeId,
    Color? backgroundColor,
    YaumiyahController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Text(ibadah['title']),
        trailing: Obx(
          () => DropdownButton<String>(
            value: ibadah['value'].value,
            items: (ibadah['options'] as List<String>).map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                ibadah['value'].value = newValue;
                _showIbadahSnackBar(ibadah['title']);
                calculatePercentages();
                controller.insertDailyRecord(
                    amalanTypeId, ibadah['id'], newValue);
              }
            },
          ),
        ),
      ),
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
