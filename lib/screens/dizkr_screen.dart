import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class DizkrScreen extends StatefulWidget {
  const DizkrScreen({super.key});

  @override
  State<DizkrScreen> createState() => _DizkrScreenState();
}

class _DizkrScreenState extends State<DizkrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.arrow_left_1,
              size: 28, color: Color(0xff13a795)),
          onPressed: () => Get.back(),
        ),
      ),
    );
  }
}
