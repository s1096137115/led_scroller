import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../models/scroller.dart';
import '../services/storage_service.dart';
import 'scroller_providers.dart';

/// 群組狀態通知器
/// 管理所有ScrollerGroup的狀態變化
/// 處理群組與Scroller之間的關聯關係
class GroupsNotifier extends StateNotifier<List<ScrollerGroup>> {
  final StorageService _storageService;
  final Ref _ref;

  GroupsNotifier(this._storageService, this._ref) : super([]) {
    _loadGroups();
  }

  // 加載與保存方法
  Future<void> _loadGroups() async {
    final groups = await _storageService.getGroups();
    state = groups;
  }

  Future<void> _saveGroups() async {
    await _storageService.saveGroups(state);
  }

  // CRUD操作
  Future<void> addGroup(ScrollerGroup group) async {
    state = [...state, group];
    await _updateScrollerRelationships(group, null);
    await _saveGroups();
  }

  Future<void> updateGroup(ScrollerGroup group) async {
    // 獲取舊群組以進行比較
    final oldGroup = state.firstWhere((g) => g.id == group.id);

    // 更新狀態
    state = [
      for (final item in state)
        if (item.id == group.id) group else item
    ];

    // 更新Scroller關係
    await _updateScrollerRelationships(group, oldGroup);
    await _saveGroups();
  }

  Future<void> deleteGroup(String id) async {
    // 獲取將被刪除的群組
    final group = state.firstWhere((g) => g.id == id);

    // 從狀態中移除群組
    state = state.where((item) => item.id != id).toList();

    // 更新Scroller關係
    await _removeGroupFromScrollers(group);
    await _saveGroups();
  }

  // 輔助方法
  Future<void> _updateScrollerRelationships(ScrollerGroup newGroup, [ScrollerGroup? oldGroup]) async {
    final scrollersNotifier = _ref.read(scrollersProvider.notifier);
    final scrollers = _ref.read(scrollersProvider);

    // 舊群組的ID列表(如果存在)
    final oldScrollerIds = oldGroup?.scrollerIds ?? [];

    // 處理從群組中移除的Scroller
    final removedScrollerIds = oldScrollerIds
        .where((id) => !newGroup.scrollerIds.contains(id))
        .toList();

    for (final scrollerId in removedScrollerIds) {
      final scroller = scrollers.firstWhere((s) => s.id == scrollerId);
      final updatedGroupIds = scroller.groupIds.where((id) => id != newGroup.id).toList();
      final updatedScroller = scroller.copyWith(
        isInGroup: updatedGroupIds.isNotEmpty,
        groupIds: updatedGroupIds,
      );
      await scrollersNotifier.updateScroller(updatedScroller);
    }

    // 處理添加到群組的新Scroller
    final addedScrollerIds = newGroup.scrollerIds
        .where((id) => !oldScrollerIds.contains(id))
        .toList();

    for (final scrollerId in addedScrollerIds) {
      final scroller = scrollers.firstWhere((s) => s.id == scrollerId);
      final updatedScroller = scroller.copyWith(
        isInGroup: true,
        groupIds: [...scroller.groupIds, newGroup.id],
      );
      await scrollersNotifier.updateScroller(updatedScroller);
    }
  }

  Future<void> _removeGroupFromScrollers(ScrollerGroup group) async {
    final scrollersNotifier = _ref.read(scrollersProvider.notifier);
    final scrollers = _ref.read(scrollersProvider);

    for (final scrollerId in group.scrollerIds) {
      final scroller = scrollers.firstWhere((s) => s.id == scrollerId);
      final updatedGroupIds = scroller.groupIds.where((gid) => gid != group.id).toList();
      final updatedScroller = scroller.copyWith(
        isInGroup: updatedGroupIds.isNotEmpty,
        groupIds: updatedGroupIds,
      );
      await scrollersNotifier.updateScroller(updatedScroller);
    }
  }
}

// 提供者定義區
// 基本提供者

/// 群組列表提供者
/// 提供全應用共享的群組列表狀態
/// 用於顯示、編輯和管理所有群組
final groupsProvider = StateNotifierProvider<GroupsNotifier, List<ScrollerGroup>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return GroupsNotifier(storageService, ref);
});

/// 當前編輯的群組提供者
/// 用於群組編輯頁面和預覽頁面之間共享正在處理的群組
/// 確保頁面間的狀態一致性
final currentGroupProvider = StateProvider<ScrollerGroup?>((ref) => null);

// 輔助提供者

/// 根據ID獲取特定群組的提供者
/// 便於在不同頁面根據ID查詢群組詳情
/// 用於導航和關聯操作
final groupByIdProvider = Provider.family<ScrollerGroup?, String>((ref, id) {
  final groups = ref.watch(groupsProvider);
  return groups.firstWhere((group) => group.id == id, orElse: () => null as ScrollerGroup);
});