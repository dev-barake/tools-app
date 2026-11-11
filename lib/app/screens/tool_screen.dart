import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/app/data/tool_catalog.dart';
import 'package:tools_app/app/models/tool_info.dart';
import 'package:tools_app/features/pdf_merger/controllers/pdf_merge_controller.dart';
import 'package:tools_app/features/qr_code_maker/controllers/qr_code_generator_controller.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';



class ToolScreen extends StatefulWidget {
  const ToolScreen({
    super.key,
    required this.toolIndex,
    required this.onHome,
    required this.contentBuilder,
  });

  final int toolIndex;
  final VoidCallback onHome;
  final Widget Function(ToolController controller) contentBuilder;

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  late final ToolController controller;
  late final String controllerTag;
  String? pdfControllerTag;
  String? qrControllerTag;

  ToolInfo get tool => toolCatalog[widget.toolIndex];

  @override
  void initState() {
    super.initState();

    controllerTag = 'tool-${widget.toolIndex}';
    controller = Get.put(
      ToolController(toolIndex: widget.toolIndex),
      tag: controllerTag,
    );

    if(widget.toolIndex == 0){
      pdfControllerTag = 'pdf-merge-${widget.toolIndex}';

      Get.put(
        PdfMergeController(),
        tag:pdfControllerTag
      );
    }
    if(widget.toolIndex ==1){
      qrControllerTag = 'qr-code-${widget.toolIndex}';

      Get.put(
        QrCodeGeneratorController(),
        tag:qrControllerTag
      );
    }
  }

  @override
  void dispose() {
    Get.delete<ToolController>(tag: controllerTag);
    if(pdfControllerTag != null){
      Get.delete<PdfMergeController>(tag: pdfControllerTag);
    }

    if(qrControllerTag != null){
      Get.delete<QrCodeGeneratorController>(tag: qrControllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 620;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            narrow ? 20 : 36,
            28,
            narrow ? 20 : 36,
            36,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 930),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: widget.onHome,
                    icon: const Icon(Icons.arrow_back_rounded, size: 17),
                    label: const Text('YOUR TOOLS'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.muted,
                      padding: EdgeInsets.zero,
                      textStyle: const TextStyle(
                        fontSize: 10,
                        letterSpacing: .8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: tool.tint.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(tool.icon, color: tool.tint, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tool.name,
                              style: TextStyle(
                                fontSize: narrow ? 25 : 30,
                                letterSpacing: -.8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              tool.description,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  widget.contentBuilder(controller),
                  const SizedBox(height: 18),
                  const PrivacyFootnote(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
