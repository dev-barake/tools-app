import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';



class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key, required this.controller});

  final ToolController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToolPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: FieldLabel('PASSWORD LENGTH')),
                  Obx(
                    () => Text(
                      '${controller.passwordLength.value}',
                      style: const TextStyle(
                        color: AppColors.lime,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => Slider(
                  value: controller.passwordLength.value.toDouble(),
                  min: 8,
                  max: 64,
                  divisions: 56,
                  activeColor: AppColors.lime,
                  inactiveColor: AppColors.line,
                  label: '${controller.passwordLength.value} characters',
                  onChanged: controller.setPasswordLength,
                ),
              ),
              const SizedBox(height: 8),
              const FieldLabel('INCLUDE CHARACTERS'),
              const SizedBox(height: 8),
              Obx(
                () => CategoryToggle(
                  title: 'Uppercase letters',
                  sample: 'ABC',
                  value: controller.upper.value,
                  onChanged: controller.setUpper,
                ),
              ),
              Obx(
                () => CategoryToggle(
                  title: 'Lowercase letters',
                  sample: 'abc',
                  value: controller.lower.value,
                  onChanged: controller.setLower,
                ),
              ),
              Obx(
                () => CategoryToggle(
                  title: 'Numbers',
                  sample: '123',
                  value: controller.numbers.value,
                  onChanged: controller.setNumbers,
                ),
              ),
              Obx(
                () => CategoryToggle(
                  title: 'Symbols',
                  sample: '!@#',
                  value: controller.symbols.value,
                  onChanged: controller.setSymbols,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Obx(() {
          final generatedPassword = controller.password.value;

          if (generatedPassword == null) {
            return const ToolPanel(
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.lavender),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Securely generated on your device. Nothing is stored.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ToolPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabel('YOUR PASSWORD'),
                const SizedBox(height: 10),
                SelectableText(
                  generatedPassword,
                  style: const TextStyle(
                    color: AppColors.lime,
                    fontFamily: 'monospace',
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: controller.copyPassword,
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy password'),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 14),
        PrimaryButton(
          label: 'Generate password',
          icon: Icons.refresh_rounded,
          onPressed: controller.generatePassword,
        ),
        ToolMessage(controller: controller),
      ],
    );
  }
}
