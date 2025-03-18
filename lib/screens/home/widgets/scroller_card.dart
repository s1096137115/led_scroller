import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/scroller.dart';
import '../../../providers/scroller_providers.dart';
import '../../../utils/font_utils.dart'; // 引入字體工具類

/// Scroller卡片組件
/// 在首頁列表中顯示單個Scroller的預覽
/// 支援左滑刪除功能和點擊預覽
class ScrollerCard extends ConsumerWidget {
  final Scroller scroller;
  final VoidCallback? onEdit;

  const ScrollerCard({
    super.key,
    required this.scroller,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Convert hex string to color using font utils
    final backgroundColor = FontUtils.hexToColor(scroller.backgroundColor);
    final textColor = FontUtils.hexToColor(scroller.textColor);

    return Dismissible(
      key: Key(scroller.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(scrollersProvider.notifier).deleteScroller(scroller.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Scroller deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Add the scroller back if user presses undo
                ref.read(scrollersProvider.notifier).addScroller(scroller);
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: onEdit, // 這裡已經修改為導航到預覽頁面的回調函數
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            scroller.text,
            // 使用 FontUtils 而不是直接設置 style
            style: FontUtils.getGoogleFontStyle(
              fontFamily: scroller.fontFamily,
              fontSize: scroller.fontSize.toDouble(),
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.visible, // 修改為 visible 移除省略號效果
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}