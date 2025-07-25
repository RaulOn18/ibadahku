import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final double fontSize;
  final double height;
  final double width;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    required this.isLoading,
    required this.text,
    this.fontSize = 16,
    this.height = 50,
    this.width = double.maxFinite,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(
            isLoading ? Colors.grey.shade300 : backgroundColor),
        foregroundColor: WidgetStateProperty.all(textColor),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 0),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(width, height),
        ), // Custom height
      ),
      onPressed: isLoading ? null : onTap,
      child: Text(
        isLoading ? "Memuat..." : text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
