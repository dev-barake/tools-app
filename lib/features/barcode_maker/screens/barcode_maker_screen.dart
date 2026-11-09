import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';



class BarcodeMakerScreen extends StatelessWidget {
  const BarcodeMakerScreen({super.key, required this.controller});

  final ToolController controller;

  @override
  Widget build(BuildContext context) {
    const formats = [
      'Code 128',
      'EAN-13',
      'UPC-A',
      'Code 39',
      'ITF',
      'Codabar',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToolPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel('BARCODE FORMAT'),
              const SizedBox(height: 9),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.barcodeFormat.value,
                  items: formats
                      .map(
                        (format) => DropdownMenuItem(
                          value: format,
                          child: Text(format),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.setBarcodeFormat(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller.valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  hintText: 'Enter text or numbers',
                ),
                onSubmitted: (_) => controller.showBarcodePreviewMessage(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const ToolPanel(
          child: EmptyFilePrompt(
            icon: Icons.view_week_rounded,
            title: 'Your barcode will appear here',
            subtitle: 'Enter a value and choose Generate barcode.',
          ),
        ),
        const SizedBox(height: 14),
        PrimaryButton(
          label: 'Generate barcode',
          icon: Icons.auto_awesome_rounded,
          onPressed: controller.generateBarcode,
        ),
        ToolMessage(controller: controller),
      ],
    );
  }
}
