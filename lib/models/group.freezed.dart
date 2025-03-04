// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScrollerGroup _$ScrollerGroupFromJson(Map<String, dynamic> json) {
  return _ScrollerGroup.fromJson(json);
}

/// @nodoc
mixin _$ScrollerGroup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get scrollerIds => throw _privateConstructorUsedError;
  Map<String, int> get scrollerOrder => throw _privateConstructorUsedError;
  int get repeatTimes => throw _privateConstructorUsedError;
  bool get repeatForever => throw _privateConstructorUsedError;

  /// Serializes this ScrollerGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScrollerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScrollerGroupCopyWith<ScrollerGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScrollerGroupCopyWith<$Res> {
  factory $ScrollerGroupCopyWith(
          ScrollerGroup value, $Res Function(ScrollerGroup) then) =
      _$ScrollerGroupCopyWithImpl<$Res, ScrollerGroup>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<String> scrollerIds,
      Map<String, int> scrollerOrder,
      int repeatTimes,
      bool repeatForever});
}

/// @nodoc
class _$ScrollerGroupCopyWithImpl<$Res, $Val extends ScrollerGroup>
    implements $ScrollerGroupCopyWith<$Res> {
  _$ScrollerGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScrollerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scrollerIds = null,
    Object? scrollerOrder = null,
    Object? repeatTimes = null,
    Object? repeatForever = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scrollerIds: null == scrollerIds
          ? _value.scrollerIds
          : scrollerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scrollerOrder: null == scrollerOrder
          ? _value.scrollerOrder
          : scrollerOrder // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      repeatTimes: null == repeatTimes
          ? _value.repeatTimes
          : repeatTimes // ignore: cast_nullable_to_non_nullable
              as int,
      repeatForever: null == repeatForever
          ? _value.repeatForever
          : repeatForever // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScrollerGroupImplCopyWith<$Res>
    implements $ScrollerGroupCopyWith<$Res> {
  factory _$$ScrollerGroupImplCopyWith(
          _$ScrollerGroupImpl value, $Res Function(_$ScrollerGroupImpl) then) =
      __$$ScrollerGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<String> scrollerIds,
      Map<String, int> scrollerOrder,
      int repeatTimes,
      bool repeatForever});
}

/// @nodoc
class __$$ScrollerGroupImplCopyWithImpl<$Res>
    extends _$ScrollerGroupCopyWithImpl<$Res, _$ScrollerGroupImpl>
    implements _$$ScrollerGroupImplCopyWith<$Res> {
  __$$ScrollerGroupImplCopyWithImpl(
      _$ScrollerGroupImpl _value, $Res Function(_$ScrollerGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScrollerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scrollerIds = null,
    Object? scrollerOrder = null,
    Object? repeatTimes = null,
    Object? repeatForever = null,
  }) {
    return _then(_$ScrollerGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scrollerIds: null == scrollerIds
          ? _value._scrollerIds
          : scrollerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scrollerOrder: null == scrollerOrder
          ? _value._scrollerOrder
          : scrollerOrder // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      repeatTimes: null == repeatTimes
          ? _value.repeatTimes
          : repeatTimes // ignore: cast_nullable_to_non_nullable
              as int,
      repeatForever: null == repeatForever
          ? _value.repeatForever
          : repeatForever // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScrollerGroupImpl
    with DiagnosticableTreeMixin
    implements _ScrollerGroup {
  const _$ScrollerGroupImpl(
      {required this.id,
      required this.name,
      required final List<String> scrollerIds,
      required final Map<String, int> scrollerOrder,
      this.repeatTimes = 1,
      this.repeatForever = false})
      : _scrollerIds = scrollerIds,
        _scrollerOrder = scrollerOrder;

  factory _$ScrollerGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScrollerGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<String> _scrollerIds;
  @override
  List<String> get scrollerIds {
    if (_scrollerIds is EqualUnmodifiableListView) return _scrollerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scrollerIds);
  }

  final Map<String, int> _scrollerOrder;
  @override
  Map<String, int> get scrollerOrder {
    if (_scrollerOrder is EqualUnmodifiableMapView) return _scrollerOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_scrollerOrder);
  }

  @override
  @JsonKey()
  final int repeatTimes;
  @override
  @JsonKey()
  final bool repeatForever;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScrollerGroup(id: $id, name: $name, scrollerIds: $scrollerIds, scrollerOrder: $scrollerOrder, repeatTimes: $repeatTimes, repeatForever: $repeatForever)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScrollerGroup'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('scrollerIds', scrollerIds))
      ..add(DiagnosticsProperty('scrollerOrder', scrollerOrder))
      ..add(DiagnosticsProperty('repeatTimes', repeatTimes))
      ..add(DiagnosticsProperty('repeatForever', repeatForever));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScrollerGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._scrollerIds, _scrollerIds) &&
            const DeepCollectionEquality()
                .equals(other._scrollerOrder, _scrollerOrder) &&
            (identical(other.repeatTimes, repeatTimes) ||
                other.repeatTimes == repeatTimes) &&
            (identical(other.repeatForever, repeatForever) ||
                other.repeatForever == repeatForever));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_scrollerIds),
      const DeepCollectionEquality().hash(_scrollerOrder),
      repeatTimes,
      repeatForever);

  /// Create a copy of ScrollerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScrollerGroupImplCopyWith<_$ScrollerGroupImpl> get copyWith =>
      __$$ScrollerGroupImplCopyWithImpl<_$ScrollerGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScrollerGroupImplToJson(
      this,
    );
  }
}

abstract class _ScrollerGroup implements ScrollerGroup {
  const factory _ScrollerGroup(
      {required final String id,
      required final String name,
      required final List<String> scrollerIds,
      required final Map<String, int> scrollerOrder,
      final int repeatTimes,
      final bool repeatForever}) = _$ScrollerGroupImpl;

  factory _ScrollerGroup.fromJson(Map<String, dynamic> json) =
      _$ScrollerGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get scrollerIds;
  @override
  Map<String, int> get scrollerOrder;
  @override
  int get repeatTimes;
  @override
  bool get repeatForever;

  /// Create a copy of ScrollerGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScrollerGroupImplCopyWith<_$ScrollerGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
