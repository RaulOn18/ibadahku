import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Timer(
    //   const Duration(seconds: 3),
    //   () => Navigator.pushReplacementNamed(context, Routes.home),
    // );
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
          width: Get.width,
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top + 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/logo-stai.png",
                    height: 64,
                  ),
                  const SizedBox(height: 16),
                  Text("Ibadahku", style: Get.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text("Developed by STAI Daarut Tauhiid Bandung",
                      style: Get.textTheme.bodySmall),
                ],
              ),
              Image.asset(
                "assets/images/logo.png",
                height: 200,
              ),
              const SizedBox(),
            ],
          ),
        ));
  }
}
