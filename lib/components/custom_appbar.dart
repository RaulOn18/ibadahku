import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibadahku/utils/utils.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCenterTitle;
  final bool isShowLeading;
  final bool isShowTrailing;
  final Widget? leading;
  final Widget? trailing;
  final PreferredSizeWidget? bottom;

  const CustomAppbar({
    super.key,
    required this.title,
    this.isCenterTitle = true,
    this.isShowLeading = true,
    this.isShowTrailing = false,
    this.leading,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      centerTitle: isCenterTitle,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      leading: !isShowLeading
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Utils.kPrimaryColor,
              ),
              onPressed: () => Get.back(),
            ),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
