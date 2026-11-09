import 'package:flutter/material.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/shared/widgets/scanner_tool_content.dart';



class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key, required this.controller});

  final ToolController controller;

  @override
  Widget build(BuildContext context) =>
      ScannerToolContent(controller: controller, isQr: true);
}
