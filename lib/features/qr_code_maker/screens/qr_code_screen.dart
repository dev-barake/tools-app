
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/features/qr_code_maker/controllers/qr_code_generator_controller.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({
    super.key,
    required this.controller,
    required this.qrController,
  });

  final ToolController controller;
  final QrCodeGeneratorController qrController;

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
                    final selected = type == qrController.qrType.value;

                    return ChoiceChip(
                      label: Text(type),
                      selected: selected,
                      onSelected: (_) => qrController.setQrType(type),
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

              Obx(() {
                final type = qrController.qrType.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (type == 'vCard') ...[
                      TextField(
                        controller: qrController.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Contact name',
                          hintText: 'John Doe',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: qrController.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone number',
                          hintText: '+254 700 000000',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: qrController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          hintText: 'hello@example.com',
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: qrController.valueController,
                        maxLines: type == 'Text' ? 4 : 1,
                        maxLength: type == 'Text' ? 1800 : null,
                        keyboardType: switch (type) {
                          'Email' => TextInputType.emailAddress,
                          'Phone' => TextInputType.phone,
                          _ => TextInputType.text,
                        },
                        decoration: InputDecoration(
                          labelText: switch (type) {
                            'URL' => 'Website address',
                            'Wi-Fi' => 'Network name',
                            'SMS' => 'SMS message',
                            _ => type,
                          },
                          hintText: switch (type) {
                            'URL' => 'https://example.com',
                            'Email' => 'hello@example.com',
                            'Phone' => '+254 700 000000',
                            'SMS' => 'Your message',
                            'Wi-Fi' => 'Network name',
                            _ => 'Type something to share',
                          },
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],

                    if (type == 'Wi-Fi') ...[
                      const SizedBox(height: 12),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: qrController.wifiSecurity.value,
                          decoration: const InputDecoration(
                            labelText: 'Security',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'WPA',
                              child: Text('WPA/WPA2'),
                            ),
                            DropdownMenuItem(
                              value: 'WEP',
                              child: Text('WEP'),
                            ),
                            DropdownMenuItem(
                              value: 'nopass',
                              child: Text('No password'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              qrController.setWifiSecurity(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => TextField(
                          controller: qrController.passwordController,
                          obscureText: qrController.hideWifiPassword.value,
                          enabled: qrController.wifiSecurity.value != 'nopass',
                          decoration: InputDecoration(
                            labelText: 'Wi-Fi password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                qrController.hideWifiPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                qrController.hideWifiPassword.toggle();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),

              const SizedBox(height: 19),
              const FieldLabel('ERROR CORRECTION'),
              const SizedBox(height: 8),

              Obx(
                () => Wrap(
                  spacing: 8,
                  children: ['Low', 'Medium', 'Quartile', 'High']
                      .map(
                        (level) => SettingPill(
                          label: level,
                          selected:
                              qrController.errorCorrectionLevel.value == level,
                          onTap: () =>
                              qrController.setErrorCorrectionLevel(level),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        ToolPanel(
          child: Obx(() {
            final imageBytes = qrController.generatedImageBytes.value;

            return Column(
              children: [
                Container(
                  width: 220,
                  height: 220,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes,
                          fit: BoxFit.contain,
                        )
                      : const Icon(
                          Icons.qr_code_2_rounded,
                          color: AppColors.qrPlaceholder,
                          size: 130,
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  imageBytes != null
                      ? 'Your QR code is ready'
                      : 'Your QR preview will appear here',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            );
          }),
        ),

        const SizedBox(height: 14),

        Obx(
          () => PrimaryButton(
            label: qrController.isGenerating.value
                ? 'Generating...'
                : 'Generate QR code',
            icon: Icons.auto_awesome_rounded,
            onPressed: qrController.isGenerating.value
                ? () {}
                : qrController.generateQrCode,
          ),
        ),

        Obx(() {
          if (qrController.errorMesssage.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: InlineMessage(
              text: qrController.errorMesssage.value,
            ),
          );
        }),
      ],
    );
  }
}
