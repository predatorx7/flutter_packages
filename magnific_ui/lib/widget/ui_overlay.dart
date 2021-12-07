import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension SystemUiOverlayStyleX on SystemUiOverlayStyle {
  SystemUiOverlayStyle merge(SystemUiOverlayStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      systemNavigationBarColor:
          other.systemNavigationBarColor ?? systemNavigationBarColor,
      systemNavigationBarDividerColor: other.systemNavigationBarDividerColor ??
          systemNavigationBarDividerColor,
      systemNavigationBarIconBrightness:
          other.systemNavigationBarIconBrightness ??
              systemNavigationBarIconBrightness,
      systemNavigationBarContrastEnforced:
          other.systemNavigationBarContrastEnforced ??
              systemNavigationBarContrastEnforced,
      statusBarColor: other.statusBarColor ?? statusBarColor,
      statusBarBrightness: other.statusBarBrightness ?? statusBarBrightness,
      statusBarIconBrightness:
          other.statusBarIconBrightness ?? statusBarIconBrightness,
      systemStatusBarContrastEnforced: other.systemStatusBarContrastEnforced ??
          systemStatusBarContrastEnforced,
    );
  }
}

class CustomSystemUiOverlay extends StatelessWidget {
  const CustomSystemUiOverlay({
    Key? key,
    this.systemUiOverlayStyle,
    this.navigationBarColor,
    required this.child,
    this.preferBackgroundColorForNavigationBar = false,
  }) : super(key: key);

  final SystemUiOverlayStyle? systemUiOverlayStyle;

  final Color? navigationBarColor;
  final bool preferBackgroundColorForNavigationBar;
  final Widget child;

  static Brightness estimateBrightness(Color color) {
    return ThemeData.estimateBrightnessForColor(color);
  }

  static Brightness estimateIconBrightness(Color color) {
    return estimateBrightness(color) == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
  }

  static SystemUiOverlayStyle systemOverlayStyleForBrightness(
      Brightness brightness) {
    return brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
  }

  static Brightness? brightnessForSystemOverlayStyle(
    SystemUiOverlayStyle? brightness,
  ) {
    if (brightness == null) return null;
    if (brightness == SystemUiOverlayStyle.dark) {
      return Brightness.light;
    }
    if (brightness == SystemUiOverlayStyle.light) {
      return Brightness.dark;
    }
    return null;
  }

  static getEffectiveSystemUiOverlayStyle(
    BuildContext context, {
    final Color? navigationBarColor,
    final bool preferBackgroundColorForNavigationBar = false,
    SystemUiOverlayStyle? systemUiOverlayStyle,
  }) {
    final theme = Theme.of(context);

    SystemUiOverlayStyle _effectiveSystemUiOverlayStyle;

    final appbarTheme = theme.appBarTheme;

    final _brightness =
        brightnessForSystemOverlayStyle(appbarTheme.systemOverlayStyle) ??
            theme.brightness;
    if (_brightness == Brightness.dark) {
      _effectiveSystemUiOverlayStyle = SystemUiOverlayStyle.light;
    } else {
      _effectiveSystemUiOverlayStyle = SystemUiOverlayStyle.dark;
    }

    if (appbarTheme.systemOverlayStyle != null) {
      _effectiveSystemUiOverlayStyle =
          _effectiveSystemUiOverlayStyle.merge(appbarTheme.systemOverlayStyle);
    }

    final statusBarColor = appbarTheme.backgroundColor;

    if (statusBarColor != null &&
        _effectiveSystemUiOverlayStyle.statusBarColor == null) {
      _effectiveSystemUiOverlayStyle = _effectiveSystemUiOverlayStyle.copyWith(
        statusBarColor: statusBarColor,
        statusBarBrightness: estimateBrightness(statusBarColor),
        statusBarIconBrightness: estimateIconBrightness(statusBarColor),
      );
    }

    final bottomNavigationColor = navigationBarColor ??
        (preferBackgroundColorForNavigationBar
            ? (theme.backgroundColor)
            : (theme.bottomAppBarTheme.color ?? theme.bottomAppBarColor));
    if (bottomNavigationColor !=
            _effectiveSystemUiOverlayStyle.systemNavigationBarColor ||
        _effectiveSystemUiOverlayStyle.systemNavigationBarColor == null) {
      _effectiveSystemUiOverlayStyle = _effectiveSystemUiOverlayStyle.copyWith(
        systemNavigationBarColor: bottomNavigationColor,
        systemNavigationBarDividerColor: null,
        systemNavigationBarIconBrightness:
            estimateIconBrightness(bottomNavigationColor),
      );
    }

    if (systemUiOverlayStyle != null) {
      _effectiveSystemUiOverlayStyle =
          _effectiveSystemUiOverlayStyle.merge(systemUiOverlayStyle);
    }

    return _effectiveSystemUiOverlayStyle;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getEffectiveSystemUiOverlayStyle(
        context,
        navigationBarColor: navigationBarColor,
        preferBackgroundColorForNavigationBar:
            preferBackgroundColorForNavigationBar,
        systemUiOverlayStyle: systemUiOverlayStyle,
      ),
      child: child,
    );
  }
}
