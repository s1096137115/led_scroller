// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScrollerGroupImpl _$$ScrollerGroupImplFromJson(Map<String, dynamic> json) =>
    _$ScrollerGroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      scrollerIds: (json['scrollerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scrollerOrder: Map<String, int>.from(json['scrollerOrder'] as Map),
      repeatTimes: (json['repeatTimes'] as num?)?.toInt() ?? 1,
      repeatForever: json['repeatForever'] as bool? ?? false,
    );

Map<String, dynamic> _$$ScrollerGroupImplToJson(_$ScrollerGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scrollerIds': instance.scrollerIds,
      'scrollerOrder': instance.scrollerOrder,
      'repeatTimes': instance.repeatTimes,
      'repeatForever': instance.repeatForever,
    };
