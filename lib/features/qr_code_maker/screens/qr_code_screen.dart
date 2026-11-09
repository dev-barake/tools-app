import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';


class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key, required this.controller});

  final ToolController controller;

  @override
  Widget build(BuildContext context) {
    const types = ['URL', 'Text', 'Email', 'Phone', 'SMS', 'Wi-Fi', 'vCard'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToolPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel('CONTENT TYPE'),
              const SizedBox(height: 10),
              Obx(
                () => Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: types.map((type) {
                    final selected = type == controller.qrType.value;

                    return ChoiceChip(
                      label: Text(type),
                      selected: selected,
                      onSelected: (_) => controller.setQrType(type),
                      selectedColor: AppColors.lime,
                      backgroundColor: AppColors.panelRaised,
                      side: const BorderSide(color: AppColors.line),
                      labelStyle: TextStyle(
                        color: selected
                            ? AppColors.ink
                            : const Color(0xFFD4DDD5),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 19),
              Obx(
                () => TextField(
                  controller: controller.valueController,
                  maxLines: controller.qrType.value == 'Text' ? 4 : 1,
                  maxLength: controller.qrType.value == 'Text' ? 1800 : null,
                  decoration: InputDecoration(
                    labelText: controller.qrType.value == 'URL'
                        ? 'Website address'
                        : controller.qrType.value,
                    hintText: switch (controller.qrType.value) {
                      'URL' => 'https://example.com',
                      'Email' => 'hello@example.com',
                      'Phone' => '+1 555 123 4567',
                      'SMS' => 'Your message',
                      'Wi-Fi' => 'Network name',
                      'vCard' => 'Name, phone, email…',
                      _ => 'Type something to share',
                    },
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              const FieldLabel('ERROR CORRECTION'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Low', 'Medium', 'Quartile', 'High']
                    .map(
                      (level) => SettingPill(
                        label: level,
                        selected: level == 'Medium',
                        onTap: () {},
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ToolPanel(
          child: Column(
            children: [
              Container(
                width: 168,
                height: 168,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  color: AppColors.qrPlaceholder,
                  size: 112,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your QR preview will appear here',
                style: TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PrimaryButton(
          label: 'Generate QR code',
          icon: Icons.auto_awesome_rounded,
          onPressed: controller.generateQrCode,
        ),
        ToolMessage(controller: controller),
      ],
    );
  }
}
