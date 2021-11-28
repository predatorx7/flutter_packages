import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Force a material ink surface over the [child].
/// This may cause performance issues. Prefer using [Ink.image] or [Ink].
class ForcedInkWell extends StatefulWidget {
  final Widget child;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final OutlinedBorder? shape;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  const ForcedInkWell({
    Key? key,
    required this.child,
    this.color,
    this.borderRadius,
    this.onPressed,
    this.onLongPress,
    this.shape,
  }) : super(key: key);

  @override
  State<ForcedInkWell> createState() => _ForcedInkWellState();

  static ButtonStyle styleFrom({
    Color? primary,
    Color? onSurface,
    Color? backgroundColor,
    Color? shadowColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    final MaterialStateProperty<Color?>? foregroundColor =
        (onSurface == null && primary == null)
            ? null
            : _TextButtonDefaultForeground(primary, onSurface);
    final MaterialStateProperty<Color?>? overlayColor =
        (primary == null) ? null : _TextButtonDefaultOverlay(primary);
    final MaterialStateProperty<MouseCursor>? mouseCursor =
        (enabledMouseCursor == null && disabledMouseCursor == null)
            ? null
            : _TextButtonDefaultMouseCursor(
                enabledMouseCursor!, disabledMouseCursor!);

    return ButtonStyle(
      textStyle: ButtonStyleButton.allOrNull<TextStyle>(textStyle),
      backgroundColor: ButtonStyleButton.allOrNull<Color>(backgroundColor),
      foregroundColor: foregroundColor,
      overlayColor: overlayColor,
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      elevation: ButtonStyleButton.allOrNull<double>(elevation),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: ButtonStyleButton.allOrNull<Size>(maximumSize),
      side: ButtonStyleButton.allOrNull<BorderSide>(side),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: mouseCursor,
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
    );
  }

  ButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.all(8),
      const EdgeInsets.symmetric(horizontal: 8),
      const EdgeInsets.symmetric(horizontal: 4),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );

    return styleFrom(
      primary: colorScheme.primary,
      onSurface: colorScheme.onSurface,
      backgroundColor: Colors.transparent,
      shadowColor: theme.shadowColor,
      elevation: 0,
      textStyle: theme.textTheme.button,
      padding: scaledPadding,
      minimumSize: const Size(64, 36),
      maximumSize: Size.infinite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      enabledMouseCursor: SystemMouseCursors.click,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: Alignment.center,
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// Returns the [TextButtonThemeData.style] of the closest
  /// [TextButtonTheme] ancestor.
  ButtonStyle? themeStyleOf(BuildContext context) {
    return TextButtonTheme.of(context).style;
  }
}

class _ForcedInkWellState extends State<ForcedInkWell> with MaterialStateMixin {
  bool get enabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    setMaterialState(MaterialState.disabled, !enabled);
  }

  @override
  void didUpdateWidget(ForcedInkWell oldWidget) {
    super.didUpdateWidget(oldWidget);
    setMaterialState(MaterialState.disabled, !enabled);
    // If the button is disabled while a press gesture is currently ongoing,
    // InkWell makes a call to handleHighlightChanged. This causes an exception
    // because it calls setState in the middle of a build. To preempt this, we
    // manually update pressed to false when this situation occurs.
    if (isDisabled && isPressed) {
      removeMaterialState(MaterialState.pressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    T? effectiveValue<T>(T? Function(ButtonStyle? style) getProperty) {
      final ButtonStyle widgetStyle = TextButton.styleFrom(
        primary: widget.color ?? Colors.transparent,
        shape: widget.shape,
        padding: EdgeInsets.zero,
        visualDensity: const VisualDensity(),
      );

      final ButtonStyle? themeStyle = widget.themeStyleOf(context);
      final ButtonStyle defaultStyle = widget.defaultStyleOf(context);

      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    T? resolve<T>(
        MaterialStateProperty<T>? Function(ButtonStyle? style) getProperty) {
      return effectiveValue(
        (ButtonStyle? style) => getProperty(style)?.resolve(materialStates),
      );
    }

    final MaterialStateMouseCursor resolvedMouseCursor = _MouseCursor(
      (Set<MaterialState> states) => effectiveValue(
          (ButtonStyle? style) => style?.mouseCursor?.resolve(states)),
    );
    final bool? resolvedEnableFeedback =
        effectiveValue((ButtonStyle? style) => style?.enableFeedback);

    final resolvedBackgroundColor =
        resolve<Color?>((ButtonStyle? style) => style?.backgroundColor);
    final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) => effectiveValue(
          (ButtonStyle? style) => style?.overlayColor?.resolve(states)),
    );
    final Duration? resolvedAnimationDuration =
        effectiveValue((ButtonStyle? style) => style?.animationDuration);
    final InteractiveInkFeatureFactory? resolvedSplashFactory = effectiveValue(
      (ButtonStyle? style) => style?.splashFactory,
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: widget.child),
        Positioned.fill(
          child: Material(
            color: resolvedBackgroundColor,
            type: resolvedBackgroundColor == null
                ? MaterialType.transparency
                : MaterialType.button,
            animationDuration: resolvedAnimationDuration!,
            child: InkWell(
              canRequestFocus: enabled,
              onTap: widget.onPressed,
              onLongPress: widget.onLongPress,
              onHighlightChanged: updateMaterialState(MaterialState.pressed),
              onHover: updateMaterialState(MaterialState.hovered),
              mouseCursor: resolvedMouseCursor,
              enableFeedback: resolvedEnableFeedback,
              onFocusChange: updateMaterialState(MaterialState.focused),
              splashFactory: resolvedSplashFactory,
              overlayColor: overlayColor,
              highlightColor: Colors.transparent,
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }
}

@immutable
class _TextButtonDefaultForeground extends MaterialStateProperty<Color?> {
  _TextButtonDefaultForeground(this.primary, this.onSurface);

  final Color? primary;
  final Color? onSurface;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return onSurface?.withOpacity(0.38);
    }
    return primary;
  }

  @override
  String toString() {
    return '{disabled: ${onSurface?.withOpacity(0.38)}, otherwise: $primary}';
  }
}

@immutable
class _TextButtonDefaultOverlay extends MaterialStateProperty<Color?> {
  _TextButtonDefaultOverlay(this.primary);

  final Color primary;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return primary.withOpacity(0.04);
    }
    if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed)) {
      return primary.withOpacity(0.12);
    }
    return null;
  }

  @override
  String toString() {
    return '{hovered: ${primary.withOpacity(0.04)}, focused,pressed: ${primary.withOpacity(0.12)}, otherwise: null}';
  }
}

@immutable
class _TextButtonDefaultMouseCursor extends MaterialStateProperty<MouseCursor>
    with Diagnosticable {
  _TextButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabledCursor;
    }
    return enabledCursor;
  }
}

class _MouseCursor extends MaterialStateMouseCursor {
  const _MouseCursor(this.resolveCallback);

  final MaterialPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<MaterialState> states) => resolveCallback(states)!;

  @override
  String get debugDescription => 'ButtonStyleButton_MouseCursor';
}
