import 'package:flutter/material.dart';

/// 顏色選擇器組件
/// 提供預設顏色選項和自定義顏色功能
/// 用於設定文字和背景顏色
class ColorPicker extends StatelessWidget {
  final String currentColor;
  final Function(String) onColorSelected;

  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorOptions = [
      '#FFFFFF', // White
      '#000000', // Black
      '#F44336', // Red
      '#E91E63', // Pink
      '#9C27B0', // Purple
      '#673AB7', // Deep Purple
      '#3F51B5', // Indigo
      '#2196F3', // Blue
      '#03A9F4', // Light Blue
      '#00BCD4', // Cyan
      '#009688', // Teal
      '#4CAF50', // Green
      '#8BC34A', // Light Green
      '#CDDC39', // Lime
      '#FFEB3B', // Yellow
      '#FFC107', // Amber
      '#FF9800', // Orange
      '#FF5722', // Deep Orange
      '#795548', // Brown
      '#9E9E9E', // Grey
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Custom color picker option
        GestureDetector(
          onTap: () {
            // For simplicity, we're not implementing a custom color dialog
            // In a real app, you would open a color picker dialog here
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.green, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.color_lens,
              color: Colors.white,
            ),
          ),
        ),
        ...colorOptions.map((color) {
          final isSelected = currentColor.toLowerCase() == color.toLowerCase();
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color(int.parse(color.replaceAll('#', '0xFF'))),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
                  : null,
            ),
          );
        }),
      ],
    );
  }
}