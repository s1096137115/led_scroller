import 'package:flutter/material.dart';
import 'dart:math' as math;

/// LED網格效果繪製
/// 模擬老式LED顯示屏的像素化遮罩效果
class LedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotRadius = 3.0;    // 增大圓點半徑
    final spacing = 7.0;      // 調整點陣間距

    // 使用 canvas.save() 和 canvas.clipRect() 限制繪製區域
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 遍歷畫布，確保覆蓋整個高度和寬度
    for (double x = 1; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        // 創建一個Path，表示圓點區域
        final dotPath = Path()
          ..addOval(Rect.fromCircle(center: Offset(x, y), radius: dotRadius));

        // 創建一個Path，表示整個網格區域
        final gridPath = Path()
          ..addRect(Rect.fromLTWH(
              x - spacing/2,
              y - spacing/2,
              spacing,
              spacing
          ));

        // 從網格Path中移除圓點Path
        final remainingPath = Path.combine(
            PathOperation.difference,
            gridPath,
            dotPath
        );

        // 繪製剩餘區域（黑色）
        final paint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

        canvas.drawPath(remainingPath, paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}