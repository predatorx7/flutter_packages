// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SettingsIdentifierTearOff {
  const _$SettingsIdentifierTearOff();

  _SettingsIdentifier call(String id) {
    return _SettingsIdentifier(
      id,
    );
  }
}

/// @nodoc
const $SettingsIdentifier = _$SettingsIdentifierTearOff();

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
abstract class _$SettingsIdentifierCopyWith<$Res>
    implements $SettingsIdentifierCopyWith<$Res> {
  factory _$SettingsIdentifierCopyWith(
          _SettingsIdentifier value, $Res Function(_SettingsIdentifier) then) =
      __$SettingsIdentifierCopyWithImpl<$Res>;
  @override
  $Res call({String id});
}

/// @nodoc
class __$SettingsIdentifierCopyWithImpl<$Res>
    extends _$SettingsIdentifierCopyWithImpl<$Res>
    implements _$SettingsIdentifierCopyWith<$Res> {
  __$SettingsIdentifierCopyWithImpl(
      _SettingsIdentifier _value, $Res Function(_SettingsIdentifier) _then)
      : super(_value, (v) => _then(v as _SettingsIdentifier));

  @override
  _SettingsIdentifier get _value => super._value as _SettingsIdentifier;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_SettingsIdentifier(
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
            other is _SettingsIdentifier &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  _$SettingsIdentifierCopyWith<_SettingsIdentifier> get copyWith =>
      __$SettingsIdentifierCopyWithImpl<_SettingsIdentifier>(this, _$identity);
}

abstract class _SettingsIdentifier implements SettingsIdentifier {
  const factory _SettingsIdentifier(String id) = _$_SettingsIdentifier;

  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$SettingsIdentifierCopyWith<_SettingsIdentifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$AppSettingsTearOff {
  const _$AppSettingsTearOff();

  _AppSettings<EXTRA, D> call<EXTRA extends Object, D extends DependencyObject>(
      {required String? flavorName,
      required String appName,
      required SatisfyDependenciesCallback<D>? dependencies,
      required ThemeData? theme,
      required SettingsIdentifier identifier,
      EXTRA? payload}) {
    return _AppSettings<EXTRA, D>(
      flavorName: flavorName,
      appName: appName,
      dependencies: dependencies,
      theme: theme,
      identifier: identifier,
      payload: payload,
    );
  }
}

/// @nodoc
const $AppSettings = _$AppSettingsTearOff();

/// @nodoc
mixin _$AppSettings<EXTRA extends Object, D extends DependencyObject> {
  String? get flavorName => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;

  /// Dependencies required for [MaterialApp] or initialization.
  /// For example, if you need to fetch intial data from a remote server.
  SatisfyDependenciesCallback<D>? get dependencies =>
      throw _privateConstructorUsedError;
  ThemeData? get theme => throw _privateConstructorUsedError;

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
      ThemeData? theme,
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
    Object? theme = freezed,
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
      theme: theme == freezed
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeData?,
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
abstract class _$AppSettingsCopyWith<
    EXTRA extends Object,
    D extends DependencyObject,
    $Res> implements $AppSettingsCopyWith<EXTRA, D, $Res> {
  factory _$AppSettingsCopyWith(_AppSettings<EXTRA, D> value,
          $Res Function(_AppSettings<EXTRA, D>) then) =
      __$AppSettingsCopyWithImpl<EXTRA, D, $Res>;
  @override
  $Res call(
      {String? flavorName,
      String appName,
      SatisfyDependenciesCallback<D>? dependencies,
      ThemeData? theme,
      SettingsIdentifier identifier,
      EXTRA? payload});

  @override
  $SettingsIdentifierCopyWith<$Res> get identifier;
}

/// @nodoc
class __$AppSettingsCopyWithImpl<
        EXTRA extends Object,
        D extends DependencyObject,
        $Res> extends _$AppSettingsCopyWithImpl<EXTRA, D, $Res>
    implements _$AppSettingsCopyWith<EXTRA, D, $Res> {
  __$AppSettingsCopyWithImpl(_AppSettings<EXTRA, D> _value,
      $Res Function(_AppSettings<EXTRA, D>) _then)
      : super(_value, (v) => _then(v as _AppSettings<EXTRA, D>));

  @override
  _AppSettings<EXTRA, D> get _value => super._value as _AppSettings<EXTRA, D>;

  @override
  $Res call({
    Object? flavorName = freezed,
    Object? appName = freezed,
    Object? dependencies = freezed,
    Object? theme = freezed,
    Object? identifier = freezed,
    Object? payload = freezed,
  }) {
    return _then(_AppSettings<EXTRA, D>(
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
      theme: theme == freezed
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeData?,
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
      required this.theme,
      required this.identifier,
      this.payload});

  @override
  final String? flavorName;
  @override
  final String appName;
  @override

  /// Dependencies required for [MaterialApp] or initialization.
  /// For example, if you need to fetch intial data from a remote server.
  final SatisfyDependenciesCallback<D>? dependencies;
  @override
  final ThemeData? theme;
  @override

  /// Identifier for the setting.
  final SettingsIdentifier identifier;
  @override
  final EXTRA? payload;

  @override
  String toString() {
    return 'AppSettings<$EXTRA, $D>(flavorName: $flavorName, appName: $appName, dependencies: $dependencies, theme: $theme, identifier: $identifier, payload: $payload)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppSettings<EXTRA, D> &&
            (identical(other.flavorName, flavorName) ||
                other.flavorName == flavorName) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.dependencies, dependencies) ||
                other.dependencies == dependencies) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            const DeepCollectionEquality().equals(other.payload, payload));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      flavorName,
      appName,
      dependencies,
      theme,
      identifier,
      const DeepCollectionEquality().hash(payload));

  @JsonKey(ignore: true)
  @override
  _$AppSettingsCopyWith<EXTRA, D, _AppSettings<EXTRA, D>> get copyWith =>
      __$AppSettingsCopyWithImpl<EXTRA, D, _AppSettings<EXTRA, D>>(
          this, _$identity);
}

abstract class _AppSettings<EXTRA extends Object, D extends DependencyObject>
    implements AppSettings<EXTRA, D> {
  const factory _AppSettings(
      {required String? flavorName,
      required String appName,
      required SatisfyDependenciesCallback<D>? dependencies,
      required ThemeData? theme,
      required SettingsIdentifier identifier,
      EXTRA? payload}) = _$_AppSettings<EXTRA, D>;

  @override
  String? get flavorName;
  @override
  String get appName;
  @override

  /// Dependencies required for [MaterialApp] or initialization.
  /// For example, if you need to fetch intial data from a remote server.
  SatisfyDependenciesCallback<D>? get dependencies;
  @override
  ThemeData? get theme;
  @override

  /// Identifier for the setting.
  SettingsIdentifier get identifier;
  @override
  EXTRA? get payload;
  @override
  @JsonKey(ignore: true)
  _$AppSettingsCopyWith<EXTRA, D, _AppSettings<EXTRA, D>> get copyWith =>
      throw _privateConstructorUsedError;
}
