import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scroller.dart';
import '../services/storage_service.dart';

/// 儲存服務提供者
/// 提供全應用共享的StorageService實例
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Scroller列表狀態通知器
/// 管理所有Scroller的狀態變化，提供CRUD操作
/// 自動處理持久化
class ScrollersNotifier extends StateNotifier<List<Scroller>> {
  final StorageService _storageService;

  ScrollersNotifier(this._storageService) : super([]) {
    _loadScrollers();
  }

  Future<void> _loadScrollers() async {
    final scrollers = await _storageService.getScrollers();
    state = scrollers;
  }

  Future<void> _saveScrollers() async {
    await _storageService.saveScrollers(state);
  }

  Future<void> addScroller(Scroller scroller) async {
    state = [...state, scroller];
    await _saveScrollers();
  }

  Future<void> updateScroller(Scroller scroller) async {
    state = [
      for (final item in state)
        if (item.id == scroller.id) scroller else item
    ];
    await _saveScrollers();
  }

  Future<void> deleteScroller(String id) async {
    state = state.where((item) => item.id != id).toList();
    await _saveScrollers();
  }

  Future<void> deleteSelectedScrollers(List<String> ids) async {
    state = state.where((item) => !ids.contains(item.id)).toList();
    await _saveScrollers();
  }
}

/// Scroller列表提供者
/// 提供全應用共享的Scroller列表狀態
final scrollersProvider = StateNotifierProvider<ScrollersNotifier, List<Scroller>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ScrollersNotifier(storageService);
});

/// 多選Scroller提供者
/// 管理使用者選擇的多個Scroller ID列表，用於群組創建和批量刪除
final selectedScrollersProvider = StateNotifierProvider<SelectedScrollersNotifier, List<String>>((ref) {
  return SelectedScrollersNotifier();
});

/// 多選Scroller狀態通知器
/// 管理選擇狀態變化，提供切換、選擇、取消選擇等操作
class SelectedScrollersNotifier extends StateNotifier<List<String>> {
  SelectedScrollersNotifier() : super([]);

  void toggle(String id) {
    if (state.contains(id)) {
      state = state.where((item) => item != id).toList();
    } else {
      state = [...state, id];
    }
  }

  void select(String id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }

  void unselect(String id) {
    state = state.where((item) => item != id).toList();
  }

  void clear() {
    state = [];
  }

  void selectAll(List<String> ids) {
    state = [...ids];
  }
}

/// 當前編輯的Scroller提供者
/// 用於編輯頁面和預覽頁面之間共享正在處理的Scroller
final currentScrollerProvider = StateProvider<Scroller?>((ref) => null);

/// 根據ID獲取特定Scroller的提供者
/// 便於在不同頁面根據ID查詢Scroller詳情
final scrollerByIdProvider = Provider.family<Scroller?, String>((ref, id) {
  final scrollers = ref.watch(scrollersProvider);
  return scrollers.firstWhere((scroller) => scroller.id == id, orElse: () => null as Scroller);
});