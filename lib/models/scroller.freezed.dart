// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scroller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Scroller _$ScrollerFromJson(Map<String, dynamic> json) {
  return _Scroller.fromJson(json);
}

/// @nodoc
mixin _$Scroller {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get fontSize => throw _privateConstructorUsedError;
  String get fontFamily => throw _privateConstructorUsedError;
  String get textColor => throw _privateConstructorUsedError;
  String get backgroundColor => throw _privateConstructorUsedError;
  ScrollDirection get direction => throw _privateConstructorUsedError;
  int get speed => throw _privateConstructorUsedError;
  bool get isInGroup => throw _privateConstructorUsedError;
  List<String> get groupIds => throw _privateConstructorUsedError;

  /// Serializes this Scroller to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Scroller
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScrollerCopyWith<Scroller> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScrollerCopyWith<$Res> {
  factory $ScrollerCopyWith(Scroller value, $Res Function(Scroller) then) =
      _$ScrollerCopyWithImpl<$Res, Scroller>;
  @useResult
  $Res call(
      {String id,
      String text,
      int fontSize,
      String fontFamily,
      String textColor,
      String backgroundColor,
      ScrollDirection direction,
      int speed,
      bool isInGroup,
      List<String> groupIds});
}

/// @nodoc
class _$ScrollerCopyWithImpl<$Res, $Val extends Scroller>
    implements $ScrollerCopyWith<$Res> {
  _$ScrollerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Scroller
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? fontSize = null,
    Object? fontFamily = null,
    Object? textColor = null,
    Object? backgroundColor = null,
    Object? direction = null,
    Object? speed = null,
    Object? isInGroup = null,
    Object? groupIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as int,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      textColor: null == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as ScrollDirection,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as int,
      isInGroup: null == isInGroup
          ? _value.isInGroup
          : isInGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      groupIds: null == groupIds
          ? _value.groupIds
          : groupIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScrollerImplCopyWith<$Res>
    implements $ScrollerCopyWith<$Res> {
  factory _$$ScrollerImplCopyWith(
          _$ScrollerImpl value, $Res Function(_$ScrollerImpl) then) =
      __$$ScrollerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      int fontSize,
      String fontFamily,
      String textColor,
      String backgroundColor,
      ScrollDirection direction,
      int speed,
      bool isInGroup,
      List<String> groupIds});
}

/// @nodoc
class __$$ScrollerImplCopyWithImpl<$Res>
    extends _$ScrollerCopyWithImpl<$Res, _$ScrollerImpl>
    implements _$$ScrollerImplCopyWith<$Res> {
  __$$ScrollerImplCopyWithImpl(
      _$ScrollerImpl _value, $Res Function(_$ScrollerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Scroller
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? fontSize = null,
    Object? fontFamily = null,
    Object? textColor = null,
    Object? backgroundColor = null,
    Object? direction = null,
    Object? speed = null,
    Object? isInGroup = null,
    Object? groupIds = null,
  }) {
    return _then(_$ScrollerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as int,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      textColor: null == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundColor: null == backgroundColor
          ? _value.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as ScrollDirection,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as int,
      isInGroup: null == isInGroup
          ? _value.isInGroup
          : isInGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      groupIds: null == groupIds
          ? _value._groupIds
          : groupIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScrollerImpl with DiagnosticableTreeMixin implements _Scroller {
  const _$ScrollerImpl(
      {required this.id,
      required this.text,
      required this.fontSize,
      required this.fontFamily,
      required this.textColor,
      required this.backgroundColor,
      this.direction = ScrollDirection.left,
      this.speed = 5,
      this.isInGroup = false,
      final List<String> groupIds = const []})
      : _groupIds = groupIds;

  factory _$ScrollerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScrollerImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final int fontSize;
  @override
  final String fontFamily;
  @override
  final String textColor;
  @override
  final String backgroundColor;
  @override
  @JsonKey()
  final ScrollDirection direction;
  @override
  @JsonKey()
  final int speed;
  @override
  @JsonKey()
  final bool isInGroup;
  final List<String> _groupIds;
  @override
  @JsonKey()
  List<String> get groupIds {
    if (_groupIds is EqualUnmodifiableListView) return _groupIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupIds);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Scroller(id: $id, text: $text, fontSize: $fontSize, fontFamily: $fontFamily, textColor: $textColor, backgroundColor: $backgroundColor, direction: $direction, speed: $speed, isInGroup: $isInGroup, groupIds: $groupIds)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Scroller'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('fontSize', fontSize))
      ..add(DiagnosticsProperty('fontFamily', fontFamily))
      ..add(DiagnosticsProperty('textColor', textColor))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('direction', direction))
      ..add(DiagnosticsProperty('speed', speed))
      ..add(DiagnosticsProperty('isInGroup', isInGroup))
      ..add(DiagnosticsProperty('groupIds', groupIds));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScrollerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor) &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.isInGroup, isInGroup) ||
                other.isInGroup == isInGroup) &&
            const DeepCollectionEquality().equals(other._groupIds, _groupIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      fontSize,
      fontFamily,
      textColor,
      backgroundColor,
      direction,
      speed,
      isInGroup,
      const DeepCollectionEquality().hash(_groupIds));

  /// Create a copy of Scroller
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScrollerImplCopyWith<_$ScrollerImpl> get copyWith =>
      __$$ScrollerImplCopyWithImpl<_$ScrollerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScrollerImplToJson(
      this,
    );
  }
}

abstract class _Scroller implements Scroller {
  const factory _Scroller(
      {required final String id,
      required final String text,
      required final int fontSize,
      required final String fontFamily,
      required final String textColor,
      required final String backgroundColor,
      final ScrollDirection direction,
      final int speed,
      final bool isInGroup,
      final List<String> groupIds}) = _$ScrollerImpl;

  factory _Scroller.fromJson(Map<String, dynamic> json) =
      _$ScrollerImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  int get fontSize;
  @override
  String get fontFamily;
  @override
  String get textColor;
  @override
  String get backgroundColor;
  @override
  ScrollDirection get direction;
  @override
  int get speed;
  @override
  bool get isInGroup;
  @override
  List<String> get groupIds;

  /// Create a copy of Scroller
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScrollerImplCopyWith<_$ScrollerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
