import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 預覽模式枚舉
/// 用於區分預覽頁面的來源和行為
enum PreviewMode {
  /// 從創建頁面來的預覽 - 尚未保存
  fromCreate,

  /// 從編輯頁面來的預覽 - 尚未保存
  fromEdit,

  /// 從首頁直接查看已存在的滾動器
  fromHome,
}

/// 預覽模式提供者
/// 用於追蹤當前預覽頁面的模式和來源
/// 影響預覽頁面的按鈕和行為
final previewModeProvider = StateProvider<PreviewMode>((ref) {
  return PreviewMode.fromHome; // 默認模式
});