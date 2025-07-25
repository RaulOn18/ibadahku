import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/components/custom_button.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionView extends StatefulWidget {
  final String version;
  final Uri link;
  const AppVersionView({super.key, required this.version, required this.link});

  @override
  State<AppVersionView> createState() => _AppVersionViewState();
}

class _AppVersionViewState extends State<AppVersionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Utils.kWhiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 8,
          children: [
            Container(
              width: Get.width,
              height: 100,
              decoration: BoxDecoration(
                  color: Utils.kPrimaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Text(
                  "New Update Available\n${widget.version}",
                  style: const TextStyle(
                    color: Utils.kWhiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Text(
              "Please update the app to the latest version to continue using the app.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            CustomButton(
              backgroundColor: Utils.kPrimaryColor,
              textColor: Colors.white,
              onTap: () {
                launchUrl(widget.link);
              },
              isLoading: false,
              text: "Update",
            )
          ],
        ),
      ),
    );
  }
}
