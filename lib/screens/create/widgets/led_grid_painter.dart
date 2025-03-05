import 'package:flutter/material.dart';
import 'dart:math' as math;

/// LED網格效果繪製
/// 建立LED點陣效果的背景
class LedGridPainter extends CustomPainter {
  final Color color;

  LedGridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = 2.0;
    final spacing = 6.0;
    final brightColor = HSLColor.fromColor(color).withLightness(0.7).toColor();
    final darkColor = HSLColor.fromColor(color).withLightness(0.3).toColor();

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // 隨機選擇亮點或暗點以創建更自然的LED效果
        final dotColor = math.Random().nextDouble() > 0.7 ? brightColor : darkColor;

        final paint = Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is LedGridPainter && oldDelegate.color != color;
  }
}