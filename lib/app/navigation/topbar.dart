
import 'package:flutter/material.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/shared/widgets/brand_mark.dart';


class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.showMenu,
    required this.onHome,
    required this.onMenu,
  });

  final bool showMenu;
  final VoidCallback onHome;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.line,
            width: .7,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showMenu)
            IconButton(
              tooltip: 'Open tools menu',
              onPressed: onMenu,
              icon: const Icon(Icons.menu_rounded),
            ),
          if (showMenu) const SizedBox(width: 4),
          InkWell(
            onTap: onHome,
            borderRadius: BorderRadius.circular(10),
            child: const Row(
              children: [
                BrandMark(size: 30),
                SizedBox(width: 10),
                Text(
                  'tidytools',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1D2921),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF304032),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: AppColors.lime,
                ),
                SizedBox(width: 6),
                Text(
                  'On-device',
                  style: TextStyle(
                    color: Color(0xFFD5E4D4),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
