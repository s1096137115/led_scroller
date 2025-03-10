import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// LED應用的顏色選擇器組件
/// 用於設定文字和背景顏色
class LedColorPicker extends StatelessWidget {
  final String currentColor;
  final ValueChanged<String> onColorSelected;

  const LedColorPicker({
    Key? key,
    required this.currentColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 預設顏色選項
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
    ];

    final normalizedColor = currentColor.toUpperCase();
    final isCustomColor = !colorOptions.contains(normalizedColor);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // 白色按鈕
        _buildColorButton(
          color: '#FFFFFF',
          isSelected: normalizedColor == '#FFFFFF',
          onTap: () => onColorSelected('#FFFFFF'),
          foregroundColor: Colors.black,
        ),

        // 黑色按鈕
        _buildColorButton(
          color: '#000000',
          isSelected: normalizedColor == '#000000',
          onTap: () => onColorSelected('#000000'),
          foregroundColor: Colors.white,
        ),

        // 自定義顏色選擇器
        GestureDetector(
          onTap: () => _showColorPickerDialog(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const SweepGradient(
                colors: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.indigo,
                  Colors.purple,
                  Colors.red,
                ],
              ),
              border: Border.all(
                color: isCustomColor ? Colors.blue : Colors.white,
                width: isCustomColor ? 2 : 1,
              ),
            ),
            child: isCustomColor
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : const Icon(Icons.color_lens, color: Colors.white, size: 20),
          ),
        ),

        // 其他預設顏色選項
        for (final colorCode in colorOptions.skip(2))
          _buildColorButton(
            color: colorCode,
            isSelected: normalizedColor == colorCode,
            onTap: () => onColorSelected(colorCode),
          ),
      ],
    );
  }

  // 構建顏色按鈕
  Widget _buildColorButton({
    required String color,
    required bool isSelected,
    required VoidCallback onTap,
    Color? foregroundColor,
  }) {
    final colorValue = _parseColor(color);
    final iconColor = foregroundColor ??
        (ThemeData.estimateBrightnessForColor(colorValue) == Brightness.dark
            ? Colors.white
            : Colors.black);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colorValue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(Icons.check, color: iconColor, size: 18)
            : null,
      ),
    );
  }

  // 安全解析顏色
  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.purple; // 預設顏色
    }
  }

  // 顯示顏色選擇對話框
  void _showColorPickerDialog(BuildContext context) {
    // 解析當前顏色
    Color pickerColor = _parseColor(currentColor);
    Color resultColor = pickerColor;

    // 顏色轉換為十六進制
    String colorToHex(Color color) {
      return '#${color.red.toRadixString(16).padLeft(2, '0')}'
          '${color.green.toRadixString(16).padLeft(2, '0')}'
          '${color.blue.toRadixString(16).padLeft(2, '0')}';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('選擇顏色'),
          backgroundColor: const Color(0xFF24243D),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                resultColor = color;
              },
              enableAlpha: false,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                onColorSelected(colorToHex(resultColor).toUpperCase());
                Navigator.of(context).pop();
              },
              child: const Text('確認', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}