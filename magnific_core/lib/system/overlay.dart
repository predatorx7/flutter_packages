import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magnific_core/theme/colors.dart';

/// Change system ui overlay colors and styles to match the theme.
class AppSystemUIOverlayStyle {
  AppSystemUIOverlayStyle._();

  /// Set overlay colors with all values of brightness and color for navigation and status bar separately.
  static SystemUiOverlayStyle set({
    required Brightness statusBarBrightness,
    required Color statusBarColor,
    Brightness? navigationBarBrightness,
    Color? navigationBarColor,
  }) {
    final _navigationBar = navigationBarColor ?? statusBarColor;
    final _navigationBarBrightness =
        navigationBarBrightness ?? statusBarBrightness;
    final _isStatusBarDark = statusBarBrightness == Brightness.dark;
    return SystemUiOverlayStyle(
      systemNavigationBarColor: _navigationBar,
      // systemNavigationBarDividerColor: null,
      statusBarColor: statusBarColor,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness:
          _navigationBarBrightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
      statusBarIconBrightness:
          _isStatusBarDark ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          _isStatusBarDark ? Brightness.dark : Brightness.light,
    );
  }

  /// Set overlay colors from a [ColorScheme].
  static SystemUiOverlayStyle fromScheme(
    ColorScheme colorScheme, {
    Color? statusBarColor,
    Color? navigationBarColor,
    Brightness statusBarBrightness = Brightness.dark,
    Brightness navigationBarBrightness = Brightness.dark,
  }) {
    final _statusbarColor = statusBarColor ??
        blendOverlayWithSurface(
          colorScheme.secondary,
        );
    final _navigationBarColor = navigationBarColor ??
        blendOverlayWithSurface(
          colorScheme.surface,
        );

    return AppSystemUIOverlayStyle.set(
      statusBarBrightness: statusBarBrightness,
      statusBarColor: _statusbarColor,
      navigationBarBrightness: navigationBarBrightness,
      navigationBarColor: _navigationBarColor,
    );
  }

  /// Set overlay colors from a [Color].
  static SystemUiOverlayStyle fromColor(
    Color color, {
    Brightness statusBarBrightness = Brightness.dark,
    Brightness navigationBarBrightness = Brightness.dark,
  }) {
    return AppSystemUIOverlayStyle.set(
      statusBarBrightness: statusBarBrightness,
      statusBarColor: color,
      navigationBarBrightness: navigationBarBrightness,
      navigationBarColor: color,
    );
  }
}
