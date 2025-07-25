import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? backgroundColor;
  final Color? surfaceColor;
  final FontWeight fontWeight;
  final double? fontSize;
  final bool isShowDot;

  const CustomBadge({
    super.key,
    required this.text,
    required this.color,
    this.fontWeight = FontWeight.normal,
    this.backgroundColor,
    this.fontSize,
    this.surfaceColor,
    this.isShowDot = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
        color: backgroundColor ?? color.withValues(alpha: 0.25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: surfaceColor ?? color,
                fontSize: fontSize ?? 12,
                fontWeight: fontWeight,
              ),
            ),
          ),
          if (isShowDot) ...[
            const SizedBox(width: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: surfaceColor ?? color,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
