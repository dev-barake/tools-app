import 'package:flutter/material.dart';

class QrColorPicker extends StatelessWidget {
  const QrColorPicker(
    {super.key,
    required this.title,
    required this.selectedColor,
    required this.onColorSelected
  });

  final String title;
  final int selectedColor;
  final ValueChanged<int> onColorSelected;

  static const List<int> colors = [
    0xFF000000,
    0xFF263238,
    0xFF1565C0,
    0xFF00897B,
    0xFF2E7D32,
    0xFF7B1FA2,
    0xFFC62828,
    0xFFEF6C00,
  ];

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10,),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: colors.map((colorValue){
            final selected = selectedColor == colorValue;
            return GestureDetector(
              onTap: ()=> onColorSelected(colorValue),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(colorValue),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? Colors.white : Colors.white24,
                    width: selected ? 3 : 1,
                  )
                ),
                child: selected ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}