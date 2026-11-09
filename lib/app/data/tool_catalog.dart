
import 'package:flutter/material.dart';
import 'package:tools_app/core/theme/app_colors.dart';


import '../models/tool_info.dart';

const List<ToolInfo> toolCatalog = [
  ToolInfo(
    name: 'Merge PDF',
    description: 'Bring documents together, in the right order.',
    icon: Icons.call_merge_rounded,
    tint: AppColors.lavender,
    tag: 'PDF',
  ),
  ToolInfo(
    name: 'QR code',
    description: 'Turn a link, note or contact into a QR.',
    icon: Icons.qr_code_2_rounded,
    tint: AppColors.lime,
    tag: 'CREATE',
  ),
  ToolInfo(
    name: 'QR scanner',
    description: 'Read a QR code from an image on your phone.',
    icon: Icons.qr_code_scanner_rounded,
    tint: AppColors.mint,
    tag: 'SCAN',
  ),
  ToolInfo(
    name: 'Password',
    description: 'Make a strong password, right on your device.',
    icon: Icons.key_rounded,
    tint: AppColors.lavender,
    tag: 'SECURE',
  ),
  ToolInfo(
    name: 'Image ↔ PDF',
    description: 'Convert images and PDF pages with ease.',
    icon: Icons.description_rounded,
    tint: AppColors.peach,
    tag: 'CONVERT',
  ),
  ToolInfo(
    name: 'Barcode reader',
    description: 'Read a barcode from an image.',
    icon: Icons.document_scanner_rounded,
    tint: AppColors.mint,
    tag: 'SCAN',
  ),
  ToolInfo(
    name: 'Barcode maker',
    description: 'Create a clean barcode ready to share.',
    icon: Icons.view_week_rounded,
    tint: AppColors.peach,
    tag: 'CREATE',
  ),
];
