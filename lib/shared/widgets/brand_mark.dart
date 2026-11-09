
import 'package:flutter/material.dart';
import 'package:tools_app/core/theme/app_colors.dart';



class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(size * .31),
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: AppColors.ink,
        size: size * .57,
      ),
    );
  }
}
