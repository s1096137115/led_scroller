import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// 跑馬燈群組模型
/// 管理多個Scroller的播放順序和重複設定
@freezed
class ScrollerGroup with _$ScrollerGroup {
  const factory ScrollerGroup({
    required String id,
    required String name,
    required List<String> scrollerIds,
    required Map<String, int> scrollerOrder,
    @Default(1) int repeatTimes,
    @Default(false) bool repeatForever,
  }) = _ScrollerGroup;

  factory ScrollerGroup.create({
    required String name,
    required List<String> scrollerIds,
    required Map<String, int> scrollerOrder,
    int repeatTimes = 1,
    bool repeatForever = false,
  }) {
    return ScrollerGroup(
      id: const Uuid().v4(),
      name: name,
      scrollerIds: scrollerIds,
      scrollerOrder: scrollerOrder,
      repeatTimes: repeatTimes,
      repeatForever: repeatForever,
    );
  }

  factory ScrollerGroup.fromJson(Map<String, dynamic> json) => _$ScrollerGroupFromJson(json);
}