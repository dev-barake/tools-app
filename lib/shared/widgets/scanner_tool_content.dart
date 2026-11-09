import 'package:flutter/material.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';


class ScannerToolContent extends StatelessWidget {
  const ScannerToolContent({
    super.key,
    required this.controller,
    required this.isQr,
  });

  final ToolController controller;
  final bool isQr;

  @override
  Widget build(BuildContext context) {
    final label = isQr ? 'Scan a QR code' : 'Read a barcode';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToolPanel(
          child: EmptyFilePrompt(
            icon: isQr
                ? Icons.qr_code_scanner_rounded
                : Icons.document_scanner_rounded,
            title: 'Choose an image',
            subtitle: isQr
                ? 'Pick an image from your phone. We’ll look for a QR code on-device.'
                : 'Pick an image from your phone. We’ll read its barcode on-device.',
          ),
        ),
        const SizedBox(height: 14),
        if (!isQr)
          const ToolPanel(
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.muted,
                  size: 18,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Supports common 1D and 2D barcode formats.',
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        if (!isQr) const SizedBox(height: 14),
        PrimaryButton(
          label: label,
          icon: Icons.add_photo_alternate_outlined,
          onPressed: () => controller.scanImage(isQr: isQr),
        ),
        ToolMessage(controller: controller),
      ],
    );
  }
}
