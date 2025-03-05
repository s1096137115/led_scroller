import 'package:flutter/material.dart';

/// 顏色選擇器組件
/// 提供預設顏色選項和自定義顏色功能
/// 用於設定文字和背景顏色
/// 根據Figma設計風格進行調整
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
    // Figma設計中的顏色選項
    final colorOptions = [
      '#FFFFFF', // White
      '#000000', // Black
      '#FF5733', // Red/Orange
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
      '#795548', // Brown
      '#9E9E9E', // Grey
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // 自定義顏色選擇器
        GestureDetector(
          onTap: () {
            // 在實際應用中這裡會打開一個自定義顏色選擇器
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.green, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: const Icon(
              Icons.color_lens,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        // 預設顏色選項
        ...colorOptions.map((color) {
          final isSelected = currentColor.toLowerCase() == color.toLowerCase();
          final colorValue = Color(int.parse(color.replaceAll('#', '0xFF')));

          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorValue,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
                  : null,
            ),
          );
        }),
      ],
    );
  }
}