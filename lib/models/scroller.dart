import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'scroller.freezed.dart';
part 'scroller.g.dart';

/// 定義滾動方向的列舉
/// 支援左、右、上、下四個方向
enum ScrollDirection { left, right, up, down }

/// LED跑馬燈資料模型
/// 儲存跑馬燈的所有屬性，包括文字內容、樣式設定與動畫效果
@freezed
class Scroller with _$Scroller {
  const factory Scroller({
    required String id,
    required String text,
    required int fontSize,
    required String fontFamily,
    required String textColor,
    required String backgroundColor,
    @Default(ScrollDirection.left) ScrollDirection direction,
    @Default(5) int speed,
    @Default(false) bool isInGroup,
    @Default([]) List<String> groupIds,
  }) = _Scroller;

  factory Scroller.create({
    required String text,
    required int fontSize,
    required String fontFamily,
    required String textColor,
    required String backgroundColor,
    ScrollDirection direction = ScrollDirection.left,
    int speed = 5,
  }) {
    return Scroller(
      id: const Uuid().v4(),
      text: text,
      fontSize: fontSize,
      fontFamily: fontFamily,
      textColor: textColor,
      backgroundColor: backgroundColor,
      direction: direction,
      speed: speed,
    );
  }

  factory Scroller.fromJson(Map<String, dynamic> json) => _$ScrollerFromJson(json);
}