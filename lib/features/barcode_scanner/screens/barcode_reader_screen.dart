import 'package:flutter/material.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/shared/widgets/scanner_tool_content.dart';


class BarcodeReaderScreen extends StatelessWidget {
  const BarcodeReaderScreen({super.key, required this.controller});

  final ToolController controller;

  @override
  Widget build(BuildContext context) =>
      ScannerToolContent(controller: controller, isQr: false);
}
