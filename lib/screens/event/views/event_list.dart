import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/components/custom_appbar.dart';
import 'package:ibadahku/components/custom_badge.dart';
import 'package:ibadahku/components/custom_button.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/screens/event/controllers/event_controller.dart';
// import 'package:ibadahku/screens/scan_qr/views/scan_qr_view.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(EventController()).fetchEventForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(EventController());
    if (controller.eventList.isEmpty) {
      controller.fetchEventForCurrentUser();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        title: "Daftar Acara",
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Flexible(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Utils.kGreyColor, width: 0.5),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.filterCategory.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    var category = controller.filterCategory[index];

                    return Obx(
                      () {
                        var isSelected = controller.selectedCategory.value ==
                            category['status'];
                        return InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            controller.selectedCategory.value =
                                category['status'];
                            controller.fetchEventForCurrentUser();
                          },
                          child: CustomBadge(
                            color: Utils.kPrimaryColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            text: category['name'],
                            surfaceColor: isSelected
                                ? Utils.kWhiteColor
                                : Utils.kPrimaryColor,
                            backgroundColor: isSelected
                                ? Utils.kPrimaryColor
                                : Utils.kWhiteColor,
                            fontSize: 14,
                            isShowDot: false,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        edgeOffset: kToolbarHeight + 90,
        onRefresh: () async {
          controller.fetchEventForCurrentUser();
        },
        child: Obx(
          () {
            if (controller.eventList.isEmpty &&
                !controller.isFetchingEvent.value) {
              return const Center(
                child: Text("Tidak ada acara"),
              );
            }
            if (controller.isFetchingEvent.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: kToolbarHeight + 90),
              itemCount: controller.eventList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                var event = controller.eventList[index];
                return Card(
                  key: ValueKey(event.id),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  elevation: 0,
                  color: Utils.kWhiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Utils.kGreyColor, width: 0.5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
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
                                                      "${DateFormat("HH:mm").format(event.startTime)} - ${DateFormat("HH:mm").format(event.endTime)}",
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
                                                        .format(
                                                            event.startTime)),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomBadge(
                              text: event.status,
                              color: event.status == "active"
                                  ? Utils.kPrimaryColor
                                  : event.status == "upcoming"
                                      ? Utils.kSecondaryColor
                                      : Colors.grey,
                              backgroundColor: event.status == "active"
                                  ? Utils.kPrimaryColor
                                  : event.status == "upcoming"
                                      ? Utils.kSecondaryColor
                                      : Colors.grey,
                              surfaceColor: Colors.white,
                              isShowDot: false,
                            )
                          ],
                        ),
                        Divider(
                          height: 24,
                          thickness: 0.7,
                          color: Utils.kGreyColor,
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            const Icon(
                              IconsaxPlusBold.profile_2user,
                              size: 20,
                              color: Utils.kPrimaryColor,
                            ),
                            Text(
                              "${event.attendedCount}/${event.eligibleCount}",
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 72,
                              height: 38,
                              child: Obx(
                                () => CustomButton(
                                  fontSize: 12,
                                  backgroundColor: Utils.kPrimaryColor,
                                  textColor: Colors.white,
                                  onTap: () async {
                                    controller.isCheckingAttendance.value =
                                        true;
                                    try {
                                      if (event.isAttended) {
                                        ScaffoldMessenger.of(Get.context!)
                                          ..clearSnackBars()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Anda sudah absen silahkan upload bukti kehadiran",
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              showCloseIcon: true,
                                            ),
                                          );
                                        Get.toNamed(Routes.uploadBuktiKehadiran,
                                            arguments: event.id);
                                        return;
                                      }
                                      if (event.status != "active") {
                                        ScaffoldMessenger.of(Get.context!)
                                          ..clearSnackBars()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Acara sudah selesai",
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              showCloseIcon: true,
                                            ),
                                          );
                                        return;
                                      }
                                      if (event.qrValue == "") {
                                        ScaffoldMessenger.of(Get.context!)
                                          ..clearSnackBars()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "QR Code belum dibuat, silahkan hubungi panitia",
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              showCloseIcon: true,
                                            ),
                                          );
                                        return;
                                      }

                                      Get.toNamed(
                                        Routes.scanQr,
                                        // arguments: ScanQrArgs(
                                        //   qrValue: event.qrValue,
                                        //   title:
                                        //       "${event.name.toString().capitalize}",
                                        //   description:
                                        //       "Scan QR Code untuk absen acara",
                                        // ),
                                      );
                                    } catch (e, stackTrace) {
                                      log("Error: when check attendance $e $stackTrace");
                                    } finally {
                                      controller.isCheckingAttendance.value =
                                          false;
                                    }
                                  },
                                  isLoading:
                                      controller.isCheckingAttendance.value,
                                  text: "Absen",
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
