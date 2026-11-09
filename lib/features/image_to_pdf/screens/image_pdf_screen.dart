import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';



class ImagePdfScreen extends StatelessWidget {
  const ImagePdfScreen({super.key, required this.controller});

  final ToolController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final imageMode = controller.conversionMode.value == 'Images to PDF';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToolPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabel('CONVERSION'),
                const SizedBox(height: 11),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Images to PDF',
                      label: Text('Images to PDF'),
                      icon: Icon(Icons.image_outlined),
                    ),
                    ButtonSegment(
                      value: 'PDF to images',
                      label: Text('PDF to images'),
                      icon: Icon(Icons.picture_as_pdf_outlined),
                    ),
                  ],
                  selected: {controller.conversionMode.value},
                  onSelectionChanged: (selection) =>
                      controller.setConversionMode(selection.first),
                  style: SegmentedButton.styleFrom(
                    foregroundColor: const Color(0xFFDDE5DD),
                    selectedForegroundColor: AppColors.ink,
                    selectedBackgroundColor: AppColors.lime,
                  ),
                ),
                const SizedBox(height: 16),
                EmptyFilePrompt(
                  icon: imageMode
                      ? Icons.add_photo_alternate_outlined
                      : Icons.picture_as_pdf_rounded,
                  title: imageMode ? 'Choose images' : 'Choose PDF files',
                  subtitle: imageMode
                      ? 'PNG, JPEG and WebP images become pages in one PDF.'
                      : 'Every page is exported as a PNG in a ZIP file.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: imageMode ? 'Select images' : 'Select PDF files',
            icon: Icons.add_rounded,
            onPressed: controller.selectConversionFiles,
          ),
          ToolMessage(controller: controller),
        ],
      );
    });
  }
}
