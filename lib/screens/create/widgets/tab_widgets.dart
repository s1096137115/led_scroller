import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// LED應用的顏色選擇器組件
/// 用於設定文字和背景顏色
/// 提供預設顏色選項和圓盤式自定義顏色選擇器
/// 根據Figma設計實現顏色排序和選中效果
/// 區分文字顏色和背景顏色的選項列表
class LedColorPicker extends StatelessWidget {
  final String currentColor;
  final ValueChanged<String> onColorSelected;
  final bool isTextColor; // 是否為文字顏色選擇器

  const LedColorPicker({
    Key? key,
    required this.currentColor,
    required this.onColorSelected,
    this.isTextColor = true, // 預設為文字顏色選擇器
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> colorOptions;

    // 根據類型選擇對應的顏色列表
    if (isTextColor) {
      // 文字顏色列表，按照Figma設計排序
      colorOptions = [
        '#FFFFFF', // White
        // Color wheel is not part of this list
        '#000000', // Black
        '#F44336', // Red
        '#FF9800', // Orange
        '#FFEB3B', // Yellow
        '#4CAF50', // Green
        '#2196F3', // Blue
        '#00BCD4', // Light Blue
        '#3F51B5', // Deep Blue
        '#9C27B0', // Purple
      ];
    } else {
      // 背景顏色列表，按照Figma設計排序，黑白位置調換
      colorOptions = [
        '#9C27B0', // Purple
        // Color wheel is not part of this list
        '#F44336', // Red
        '#FF9800', // Orange
        '#FFEB3B', // Yellow
        '#4CAF50', // Green
        '#2196F3', // Blue
        '#00BCD4', // Light Blue
        '#3F51B5', // Deep Blue
        '#000000', // Black
        '#FFFFFF', // White
      ];
    }

    final normalizedColor = currentColor.toUpperCase();

    // 檢查當前顏色是否為預設顏色之一
    bool isCustomColor = true;
    for (final color in colorOptions) {
      if (_compareColors(normalizedColor, color)) {
        isCustomColor = false;
        break;
      }
    }

    return Wrap(
      spacing: 16, // 增加間距以適應更大的選中尺寸
      runSpacing: 16, // 增加間距以適應更大的選中尺寸
      children: [
        // 第一個顏色按鈕
        _buildColorButton(
          color: colorOptions[0],
          isSelected: _compareColors(normalizedColor, colorOptions[0]),
          onTap: () => onColorSelected(colorOptions[0]),
        ),

        // 自定義顏色選擇器
        GestureDetector(
          onTap: () => _showColorPickerDialog(context),
          child: Container(
            width: isCustomColor ? 60.0 : 40.0,
            height: isCustomColor ? 60.0 : 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
              border: isCustomColor ? Border.all(
                color: Colors.white,
                width: 2,
              ) : null,
            ),
          ),
        ),

        // 剩餘的預設顏色按鈕
        for (int i = 1; i < colorOptions.length; i++)
          _buildColorButton(
            color: colorOptions[i],
            isSelected: _compareColors(normalizedColor, colorOptions[i]),
            onTap: () => onColorSelected(colorOptions[i]),
          ),
      ],
    );
  }

  // 更新 StyleTab 中使用的方法，傳遞適當的 isTextColor 參數
  static Widget buildTextColorPicker({
    required String currentColor,
    required ValueChanged<String> onColorSelected,
  }) {
    return LedColorPicker(
      currentColor: currentColor,
      onColorSelected: onColorSelected,
      isTextColor: true,
    );
  }

  static Widget buildBackgroundColorPicker({
    required String currentColor,
    required ValueChanged<String> onColorSelected,
  }) {
    return LedColorPicker(
      currentColor: currentColor,
      onColorSelected: onColorSelected,
      isTextColor: false,
    );
  }

  // 構建顏色按鈕
  Widget _buildColorButton({
    required String color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorValue = _parseColor(color);
    final double buttonSize = isSelected ? 60.0 : 40.0; // 選中後變大

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorValue,
          border: isSelected ? Border.all(
            color: Colors.white,
            width: 2,
          ) : null,
        ),
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

  // 比較兩個顏色是否相同
  // 允許一定的誤差，因為從ColorPicker選擇的顏色可能與預設顏色略有不同
  bool _compareColors(String color1, String color2) {
    try {
      final c1 = _parseColor(color1);
      final c2 = _parseColor(color2);

      // 直接比較十六進制值
      if (color1 == color2) return true;

      // 允許少量色差
      const tolerance = 5;
      return (c1.red - c2.red).abs() <= tolerance &&
          (c1.green - c2.green).abs() <= tolerance &&
          (c1.blue - c2.blue).abs() <= tolerance;
    } catch (e) {
      return color1 == color2;
    }
  }

  // 顯示圓盤式顏色選擇對話框
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
              paletteType: PaletteType.hueWheel, // 使用圓盤式顏色選擇器
              enableAlpha: false,
              labelTypes: const [], // 簡化UI，不顯示標籤
              pickerAreaHeightPercent: 0.8, // 增加顏色選擇區域的高度百分比
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