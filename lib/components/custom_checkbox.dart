import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    super.key,
    this.width = 24.0,
    this.height = 24.0,
    this.color,
    this.iconSize,
    this.onChanged,
    this.checkColor,
    required this.isChecked,
  });

  final double width;
  final double height;
  final Color? color;
  final double? iconSize;
  final Color? checkColor;
  final bool isChecked;
  final Function(bool?)? onChanged;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => isChecked = !isChecked);
        widget.onChanged?.call(isChecked);
      },
      child: Row(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: isChecked == true
                    ? widget.checkColor ?? Colors.blue
                    : widget.color ?? Colors.grey.shade500,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: isChecked == true
                ? Container(
                    decoration: BoxDecoration(
                      color: widget.checkColor,
                    ),
                    child: Icon(
                      Icons.check,
                      size: widget.iconSize,
                      weight: 2.0,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            "Remember me",
            style: TextStyle(
              color: isChecked == true
                  ? widget.checkColor ?? Colors.blue
                  : widget.color ?? Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
