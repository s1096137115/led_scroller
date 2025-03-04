// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScrollerImpl _$$ScrollerImplFromJson(Map<String, dynamic> json) =>
    _$ScrollerImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      fontSize: (json['fontSize'] as num).toInt(),
      fontFamily: json['fontFamily'] as String,
      textColor: json['textColor'] as String,
      backgroundColor: json['backgroundColor'] as String,
      direction:
          $enumDecodeNullable(_$ScrollDirectionEnumMap, json['direction']) ??
              ScrollDirection.left,
      speed: (json['speed'] as num?)?.toInt() ?? 5,
      isInGroup: json['isInGroup'] as bool? ?? false,
      groupIds: (json['groupIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ScrollerImplToJson(_$ScrollerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'fontSize': instance.fontSize,
      'fontFamily': instance.fontFamily,
      'textColor': instance.textColor,
      'backgroundColor': instance.backgroundColor,
      'direction': _$ScrollDirectionEnumMap[instance.direction]!,
      'speed': instance.speed,
      'isInGroup': instance.isInGroup,
      'groupIds': instance.groupIds,
    };

const _$ScrollDirectionEnumMap = {
  ScrollDirection.left: 'left',
  ScrollDirection.right: 'right',
  ScrollDirection.up: 'up',
  ScrollDirection.down: 'down',
};
