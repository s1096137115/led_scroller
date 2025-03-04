import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/scroller.dart';
import '../../../providers/scroller_providers.dart';

/// Scroller卡片組件
/// 在首頁列表中顯示單個Scroller的預覽
/// 支援左滑刪除功能和點擊編輯
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
    // Convert hex string to color
    final backgroundColor = Color(int.parse(scroller.backgroundColor.replaceAll('#', '0xFF')));
    final textColor = Color(int.parse(scroller.textColor.replaceAll('#', '0xFF')));

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
        onTap: onEdit,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            scroller.text,
            style: TextStyle(
              color: textColor,
              fontSize: scroller.fontSize.toDouble(),
              fontFamily: scroller.fontFamily,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}