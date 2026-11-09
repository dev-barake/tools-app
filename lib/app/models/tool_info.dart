
import 'package:flutter/material.dart';

class ToolInfo {
  const ToolInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.tint,
    required this.tag,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color tint;
  final String tag;
}
