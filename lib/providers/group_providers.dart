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

  Future<void> _loadGroups() async {
    final groups = await _storageService.getGroups();
    state = groups;
  }

  Future<void> _saveGroups() async {
    await _storageService.saveGroups(state);
  }

  Future<void> addGroup(ScrollerGroup group) async {
    state = [...state, group];

    // Update scrollers to mark them as part of a group
    final scrollersNotifier = _ref.read(scrollersProvider.notifier);
    final scrollers = _ref.read(scrollersProvider);

    for (final scrollerId in group.scrollerIds) {
      final scroller = scrollers.firstWhere((s) => s.id == scrollerId);
      final updatedScroller = scroller.copyWith(
        isInGroup: true,
        groupIds: [...scroller.groupIds, group.id],
      );
      await scrollersNotifier.updateScroller(updatedScroller);
    }

    await _saveGroups();
  }

  Future<void> updateGroup(ScrollerGroup group) async {
    state = [
      for (final item in state)
        if (item.id == group.id) group else item
    ];

    // Update scrollers to reflect group changes
    final scrollersNotifier = _ref.read(scrollersProvider.notifier);
    final scrollers = _ref.read(scrollersProvider);

    // Get the old group
    final oldGroup = state.firstWhere((g) => g.id == group.id);

    // Remove from scrollers no longer in the group
    final removedScrollerIds = oldGroup.scrollerIds
        .where((id) => !group.scrollerIds.contains(id))
        .toList();

    for (final scrollerId in removedScrollerIds) {
      final scroller = scrollers.firstWhere((s) => s.id == scrollerId);
      final updatedGroupIds = scroller.groupIds.where((id) => id != group.id).toList();
      final updatedScroller = scroller.copyWith(
        isInGroup: updatedGroupIds.isNotEmpty,
        groupIds: updatedGroupIds,
      );
      await scrollersNotifier.updateScroller(updatedScroller);
    }

    // Add to new scrollers in the group
    final addedScrollerIds = group.scrollerIds
        .where((id) => !oldGroup.scrollerIds.contains(id))
        .toList();

    for (final scrollerId in addedScrollerIds) {
      final scroller = scrollers.firstWhere((s) => s.id == scrollerId);
      final updatedScroller = scroller.copyWith(
        isInGroup: true,
        groupIds: [...scroller.groupIds, group.id],
      );
      await scrollersNotifier.updateScroller(updatedScroller);
    }

    await _saveGroups();
  }

  Future<void> deleteGroup(String id) async {
    // Get the group to be deleted
    final group = state.firstWhere((g) => g.id == id);

    // Remove the group from state
    state = state.where((item) => item.id != id).toList();

    // Update scrollers to remove association with this group
    final scrollersNotifier = _ref.read(scrollersProvider.notifier);
    final scrollers = _ref.read(scrollersProvider);

    for (final scrollerId in group.scrollerIds) {
      final scroller = scrollers.firstWhere((s) => s.id == scrollerId);
      final updatedGroupIds = scroller.groupIds.where((gid) => gid != id).toList();
      final updatedScroller = scroller.copyWith(
        isInGroup: updatedGroupIds.isNotEmpty,
        groupIds: updatedGroupIds,
      );
      await scrollersNotifier.updateScroller(updatedScroller);
    }

    await _saveGroups();
  }
}

/// 群組列表提供者
/// 提供全應用共享的群組列表狀態
final groupsProvider = StateNotifierProvider<GroupsNotifier, List<ScrollerGroup>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return GroupsNotifier(storageService, ref);
});

/// 根據ID獲取特定群組的提供者
/// 便於在不同頁面根據ID查詢群組詳情
final groupByIdProvider = Provider.family<ScrollerGroup?, String>((ref, id) {
  final groups = ref.watch(groupsProvider);
  return groups.firstWhere((group) => group.id == id, orElse: () => null as ScrollerGroup);
});

/// 當前編輯的群組提供者
/// 用於群組編輯頁面和預覽頁面之間共享正在處理的群組
final currentGroupProvider = StateProvider<ScrollerGroup?>((ref) => null);