import 'data/settings.dart';

/// Please use value of [appSettings] instead of creating an instance.
class _AppSettingsManager {
  AppSettings? _selectedSettings;

  AppSettings get settings => _selectedSettings!;

  /// Set application settings. Preferably call this method in main method.
  set settings(AppSettings? value) {
    assert(
      _selectedSettings == null,
      'Application settings must be only set once.',
    );
    _selectedSettings = value;
  }

  /// Returns true if the current settings' identifier matches with [identifier].
  bool isFor(SettingsIdentifier identifier) {
    return settings.identifier == identifier;
  }

  SettingsIdentifier get identifier => settings.identifier;
}

/// Manages the current application flavor settings. Can be used to set, get and identify the current settings.
///
/// Use `settingsManager.settings = YourAppBuildFlavorSettings()` setter to specify the settings.
final settingsManager = _AppSettingsManager();

/// The current application flavor settings.
/// [_AppSettingsManager.isOf] is also an alternative to this if you want to check the current settings.
AppSettings<Object, DependencyObject> get currentSettings => settingsManager.settings;
