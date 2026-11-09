
import 'package:flutter/material.dart';
import 'package:tools_app/app/data/tool_catalog.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/tool_card.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenTool,
  });

  final ValueChanged<int> onOpenTool;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontal = width < 500 ? 20.0 : 34.0;
        final columns = width >= 1050
            ? 3
            : width >= 650
                ? 2
                : 1;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            28,
            horizontal,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Eyebrow(
                    icon: Icons.waving_hand_rounded,
                    text: 'YOUR PRIVATE WORKSPACE',
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'A little less busywork.',
                    style: TextStyle(
                      fontSize: width < 500 ? 29 : 38,
                      height: 1.12,
                      letterSpacing: -1.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Handy tools for everyday files. All on your device.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _PrivacyBanner(compact: width < 520),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text(
                        'Your toolkit',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -.3,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.panelRaised,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          toolCatalog.length.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (width > 460)
                        const Text(
                          'PICK UP WHERE YOU LEFT OFF',
                          style: TextStyle(
                            color: AppColors.muted,
                            letterSpacing: .7,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GridView.builder(
                    itemCount: toolCatalog.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 158,
                    ),
                    itemBuilder: (context, index) {
                      return ToolCard(
                        tool: toolCatalog[index],
                        onTap: () => onOpenTool(index + 1),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const _LocalNote(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.lime),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.lime,
            letterSpacing: 1.25,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 17),
      decoration: BoxDecoration(
        color: AppColors.privacyBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.privacyBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: AppColors.lime.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.lime,
              size: 19,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Private by design',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your files never leave this device.',
                  style: TextStyle(
                    color: AppColors.privacyText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (!compact)
            const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF84947D),
              size: 19,
            ),
        ],
      ),
    );
  }
}

class _LocalNote extends StatelessWidget {
  const _LocalNote();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.offline_bolt_outlined,
              size: 14,
              color: AppColors.muted,
            ),
            SizedBox(width: 7),
            Text(
              'No accounts. No uploads. Just useful tools.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
