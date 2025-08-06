import 'package:flutter/material.dart';

class YaumiyahListModel {
  final String title;
  final Color color;
  final IconData icon;
  final List<Map<String, dynamic>> listIbadah;

  YaumiyahListModel({
    required this.title,
    required this.color,
    required this.icon,
    required this.listIbadah,
  });

  @override
  String toString() {
    return 'YaumiyahListModel(title: $title, color: $color, icon: $icon, listIbadah: $listIbadah)';
  }
}
