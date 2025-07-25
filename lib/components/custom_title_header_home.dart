import 'package:flutter/material.dart';

class CustomTitleHeaderHome extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final Widget? trailing;

  const CustomTitleHeaderHome({
    super.key,
    required this.title,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
    this.fontColor = Colors.black,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: fontColor,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
