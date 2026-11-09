
import 'package:flutter/material.dart';
import 'package:tools_app/app/data/tool_catalog.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/brand_mark.dart';



class NavigationPanel extends StatelessWidget {
  const NavigationPanel({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 28),
            child: Row(
              children: [
                BrandMark(size: 35),
                SizedBox(width: 11),
                Text(
                  'tidytools',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const _SectionLabel('WORKSPACE'),
          const SizedBox(height: 9),
          _NavItem(
            icon: Icons.grid_view_rounded,
            title: 'Overview',
            selected: selected == 0,
            onTap: () => onSelect(0),
          ),
          const SizedBox(height: 25),
          const _SectionLabel('YOUR TOOLS'),
          const SizedBox(height: 9),
          ...List<Widget>.generate(toolCatalog.length, (index) {
            final tool = toolCatalog[index];

            return _NavItem(
              icon: tool.icon,
              title: tool.name,
              selected: selected == index + 1,
              tint: tool.tint,
              onTap: () => onSelect(index + 1),
            );
          }),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_moon_outlined,
                  color: AppColors.lime,
                  size: 19,
                ),
                SizedBox(height: 10),
                Text(
                  'Your files stay yours.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Everything happens locally on your device.',
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.4,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.muted,
          letterSpacing: 1.15,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.tint = AppColors.muted,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Material(
        color: selected
            ? AppColors.selectedNavigation
            : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 11,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? AppColors.lime : tint,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : AppColors.navigationText,
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
