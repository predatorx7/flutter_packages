import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class AppLocale {
  AppLocale._();

  static List<Locale> deviceLocales() {
    final _platformDispatcher = WidgetsBinding.instance?.platformDispatcher;
    if (_platformDispatcher != null) {
      return _platformDispatcher.locales;
    }
    return ui.window.locales;
  }

  static Locale deviceLocale() {
    final _platformDispatcher = WidgetsBinding.instance?.platformDispatcher;
    if (_platformDispatcher != null) {
      return _platformDispatcher.locale;
    }
    return ui.window.locale;
  }
}
