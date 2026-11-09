import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/core/theme/app_colors.dart';



class ToolPanel extends StatelessWidget {
  const ToolPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}

class EmptyFilePrompt extends StatelessWidget {
  const EmptyFilePrompt({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.panelRaised.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.lavender, size: 29),
          const SizedBox(height: 11),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 9,
        letterSpacing: 1,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class SettingPill extends StatelessWidget {
  const SettingPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.lime.withValues(alpha: .14)
              : AppColors.panelRaised,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.lime : AppColors.line),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.lime : const Color(0xFFCFD8D0),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CategoryToggle extends StatelessWidget {
  const CategoryToggle({
    super.key,
    required this.title,
    required this.sample,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String sample;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Color(0xFFD8E0D8)),
            ),
          ),
          Text(
            sample,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.lime,
            inactiveTrackColor: AppColors.panelRaised,
          ),
        ],
      ),
    );
  }
}

class InlineMessage extends StatelessWidget {
  const InlineMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.messageBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.messageBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.messageText, fontSize: 11),
      ),
    );
  }
}

class ToolMessage extends StatelessWidget {
  const ToolMessage({super.key, required this.controller});

  final ToolController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final text = controller.message.value;

      if (text == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InlineMessage(text: text),
      );
    });
  }
}

class PrivacyFootnote extends StatelessWidget {
  const PrivacyFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline_rounded, color: AppColors.muted, size: 13),
        SizedBox(width: 6),
        Text(
          'Private and on-device',
          style: TextStyle(color: AppColors.muted, fontSize: 10),
        ),
      ],
    );
  }
}
