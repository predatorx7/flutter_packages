// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SettingsIdentifier {
  String get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsIdentifierCopyWith<SettingsIdentifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsIdentifierCopyWith<$Res> {
  factory $SettingsIdentifierCopyWith(
          SettingsIdentifier value, $Res Function(SettingsIdentifier) then) =
      _$SettingsIdentifierCopyWithImpl<$Res>;
  $Res call({String id});
}

/// @nodoc
class _$SettingsIdentifierCopyWithImpl<$Res>
    implements $SettingsIdentifierCopyWith<$Res> {
  _$SettingsIdentifierCopyWithImpl(this._value, this._then);

  final SettingsIdentifier _value;
  // ignore: unused_field
  final $Res Function(SettingsIdentifier) _then;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_SettingsIdentifierCopyWith<$Res>
    implements $SettingsIdentifierCopyWith<$Res> {
  factory _$$_SettingsIdentifierCopyWith(_$_SettingsIdentifier value,
          $Res Function(_$_SettingsIdentifier) then) =
      __$$_SettingsIdentifierCopyWithImpl<$Res>;
  @override
  $Res call({String id});
}

/// @nodoc
class __$$_SettingsIdentifierCopyWithImpl<$Res>
    extends _$SettingsIdentifierCopyWithImpl<$Res>
    implements _$$_SettingsIdentifierCopyWith<$Res> {
  __$$_SettingsIdentifierCopyWithImpl(
      _$_SettingsIdentifier _value, $Res Function(_$_SettingsIdentifier) _then)
      : super(_value, (v) => _then(v as _$_SettingsIdentifier));

  @override
  _$_SettingsIdentifier get _value => super._value as _$_SettingsIdentifier;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_$_SettingsIdentifier(
      id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SettingsIdentifier implements _SettingsIdentifier {
  const _$_SettingsIdentifier(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'SettingsIdentifier(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SettingsIdentifier &&
            const DeepCollectionEquality().equals(other.id, id));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(id));

  @JsonKey(ignore: true)
  @override
  _$$_SettingsIdentifierCopyWith<_$_SettingsIdentifier> get copyWith =>
      __$$_SettingsIdentifierCopyWithImpl<_$_SettingsIdentifier>(
          this, _$identity);
}

abstract class _SettingsIdentifier implements SettingsIdentifier {
  const factory _SettingsIdentifier(final String id) = _$_SettingsIdentifier;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_SettingsIdentifierCopyWith<_$_SettingsIdentifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppSettings<EXTRA extends Object, D extends DependencyObject> {
  String? get flavorName => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;

  /// Dependencies required for [MaterialApp] or initialization.
  /// For example, if you need to fetch intial data from a remote server.
  SatisfyDependenciesCallback<D>? get dependencies =>
      throw _privateConstructorUsedError;

  /// Identifier for the setting.
  SettingsIdentifier get identifier => throw _privateConstructorUsedError;
  EXTRA? get payload => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppSettingsCopyWith<EXTRA, D, AppSettings<EXTRA, D>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<EXTRA extends Object,
    D extends DependencyObject, $Res> {
  factory $AppSettingsCopyWith(AppSettings<EXTRA, D> value,
          $Res Function(AppSettings<EXTRA, D>) then) =
      _$AppSettingsCopyWithImpl<EXTRA, D, $Res>;
  $Res call(
      {String? flavorName,
      String appName,
      SatisfyDependenciesCallback<D>? dependencies,
      SettingsIdentifier identifier,
      EXTRA? payload});

  $SettingsIdentifierCopyWith<$Res> get identifier;
}

/// @nodoc
class _$AppSettingsCopyWithImpl<
    EXTRA extends Object,
    D extends DependencyObject,
    $Res> implements $AppSettingsCopyWith<EXTRA, D, $Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  final AppSettings<EXTRA, D> _value;
  // ignore: unused_field
  final $Res Function(AppSettings<EXTRA, D>) _then;

  @override
  $Res call({
    Object? flavorName = freezed,
    Object? appName = freezed,
    Object? dependencies = freezed,
    Object? identifier = freezed,
    Object? payload = freezed,
  }) {
    return _then(_value.copyWith(
      flavorName: flavorName == freezed
          ? _value.flavorName
          : flavorName // ignore: cast_nullable_to_non_nullable
              as String?,
      appName: appName == freezed
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      dependencies: dependencies == freezed
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as SatisfyDependenciesCallback<D>?,
      identifier: identifier == freezed
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as SettingsIdentifier,
      payload: payload == freezed
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as EXTRA?,
    ));
  }

  @override
  $SettingsIdentifierCopyWith<$Res> get identifier {
    return $SettingsIdentifierCopyWith<$Res>(_value.identifier, (value) {
      return _then(_value.copyWith(identifier: value));
    });
  }
}

/// @nodoc
abstract class _$$_AppSettingsCopyWith<
    EXTRA extends Object,
    D extends DependencyObject,
    $Res> implements $AppSettingsCopyWith<EXTRA, D, $Res> {
  factory _$$_AppSettingsCopyWith(_$_AppSettings<EXTRA, D> value,
          $Res Function(_$_AppSettings<EXTRA, D>) then) =
      __$$_AppSettingsCopyWithImpl<EXTRA, D, $Res>;
  @override
  $Res call(
      {String? flavorName,
      String appName,
      SatisfyDependenciesCallback<D>? dependencies,
      SettingsIdentifier identifier,
      EXTRA? payload});

  @override
  $SettingsIdentifierCopyWith<$Res> get identifier;
}

/// @nodoc
class __$$_AppSettingsCopyWithImpl<
        EXTRA extends Object,
        D extends DependencyObject,
        $Res> extends _$AppSettingsCopyWithImpl<EXTRA, D, $Res>
    implements _$$_AppSettingsCopyWith<EXTRA, D, $Res> {
  __$$_AppSettingsCopyWithImpl(_$_AppSettings<EXTRA, D> _value,
      $Res Function(_$_AppSettings<EXTRA, D>) _then)
      : super(_value, (v) => _then(v as _$_AppSettings<EXTRA, D>));

  @override
  _$_AppSettings<EXTRA, D> get _value =>
      super._value as _$_AppSettings<EXTRA, D>;

  @override
  $Res call({
    Object? flavorName = freezed,
    Object? appName = freezed,
    Object? dependencies = freezed,
    Object? identifier = freezed,
    Object? payload = freezed,
  }) {
    return _then(_$_AppSettings<EXTRA, D>(
      flavorName: flavorName == freezed
          ? _value.flavorName
          : flavorName // ignore: cast_nullable_to_non_nullable
              as String?,
      appName: appName == freezed
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      dependencies: dependencies == freezed
          ? _value.dependencies
          : dependencies // ignore: cast_nullable_to_non_nullable
              as SatisfyDependenciesCallback<D>?,
      identifier: identifier == freezed
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as SettingsIdentifier,
      payload: payload == freezed
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as EXTRA?,
    ));
  }
}

/// @nodoc

class _$_AppSettings<EXTRA extends Object, D extends DependencyObject>
    implements _AppSettings<EXTRA, D> {
  const _$_AppSettings(
      {required this.flavorName,
      required this.appName,
      required this.dependencies,
      required this.identifier,
      this.payload});

  @override
  final String? flavorName;
  @override
  final String appName;

  /// Dependencies required for [MaterialApp] or initialization.
  /// For example, if you need to fetch intial data from a remote server.
  @override
  final SatisfyDependenciesCallback<D>? dependencies;

  /// Identifier for the setting.
  @override
  final SettingsIdentifier identifier;
  @override
  final EXTRA? payload;

  @override
  String toString() {
    return 'AppSettings<$EXTRA, $D>(flavorName: $flavorName, appName: $appName, dependencies: $dependencies, identifier: $identifier, payload: $payload)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppSettings<EXTRA, D> &&
            const DeepCollectionEquality()
                .equals(other.flavorName, flavorName) &&
            const DeepCollectionEquality().equals(other.appName, appName) &&
            (identical(other.dependencies, dependencies) ||
                other.dependencies == dependencies) &&
            const DeepCollectionEquality()
                .equals(other.identifier, identifier) &&
            const DeepCollectionEquality().equals(other.payload, payload));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(flavorName),
      const DeepCollectionEquality().hash(appName),
      dependencies,
      const DeepCollectionEquality().hash(identifier),
      const DeepCollectionEquality().hash(payload));

  @JsonKey(ignore: true)
  @override
  _$$_AppSettingsCopyWith<EXTRA, D, _$_AppSettings<EXTRA, D>> get copyWith =>
      __$$_AppSettingsCopyWithImpl<EXTRA, D, _$_AppSettings<EXTRA, D>>(
          this, _$identity);
}

abstract class _AppSettings<EXTRA extends Object, D extends DependencyObject>
    implements AppSettings<EXTRA, D> {
  const factory _AppSettings(
      {required final String? flavorName,
      required final String appName,
      required final SatisfyDependenciesCallback<D>? dependencies,
      required final SettingsIdentifier identifier,
      final EXTRA? payload}) = _$_AppSettings<EXTRA, D>;

  @override
  String? get flavorName => throw _privateConstructorUsedError;
  @override
  String get appName => throw _privateConstructorUsedError;
  @override

  /// Dependencies required for [MaterialApp] or initialization.
  /// For example, if you need to fetch intial data from a remote server.
  SatisfyDependenciesCallback<D>? get dependencies =>
      throw _privateConstructorUsedError;
  @override

  /// Identifier for the setting.
  SettingsIdentifier get identifier => throw _privateConstructorUsedError;
  @override
  EXTRA? get payload => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AppSettingsCopyWith<EXTRA, D, _$_AppSettings<EXTRA, D>> get copyWith =>
      throw _privateConstructorUsedError;
}
