import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

/// Extend this to pass custom dependency based on your project
abstract class DependencyObject {}

typedef SatisfyDependenciesCallback<D extends DependencyObject> = Future<void>
    Function(D object);

@immutable
@freezed

/// An immutable class that identifies a settings [AppSettings].
class SettingsIdentifier with _$SettingsIdentifier {
  const factory SettingsIdentifier(String id) = _SettingsIdentifier;
}

/// Application settings.
///
/// * settingsFor: primary unique identifier for the setting.
/// * dependencies: required for [MaterialApp] or initialization.
///                 For example, if you need to fetch intial data from a remote server.
/// * theme: application theme.
@immutable
@freezed
class AppSettings<EXTRA extends Object, D extends DependencyObject>
    with _$AppSettings<EXTRA, D> {
  const factory AppSettings({
    required String? flavorName,
    required String appName,

    /// Dependencies required for [MaterialApp] or initialization.
    /// For example, if you need to fetch intial data from a remote server.
    required SatisfyDependenciesCallback<D>? dependencies,

    /// Identifier for the setting.
    required SettingsIdentifier identifier,
    EXTRA? payload,
  }) = _AppSettings<EXTRA, D>;
}
