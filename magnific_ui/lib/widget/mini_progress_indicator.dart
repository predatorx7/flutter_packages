import 'package:flutter/material.dart';

/// Creates a customizable & mini-version of [CircularProgressIndicator].
class MiniCircularProgressIndicator extends StatelessWidget {
  ///  The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  final double? value;

  /// The color of this progress indicator. Defaults to
  /// `Theme.of(context).colorScheme.secondary`.
  final Color? color;

  /// An animated color value for this indicator. If this is provided then [color] is ignored.
  final Animation<Color?>? valueColor;

  /// Insets that is applied on the progress indicator.
  /// Defaults to `const EdgeInsets.symmetric(horizontal: 14.0)`
  final EdgeInsetsGeometry? padding;

  /// Determines the axis direction of the flex widget.
  /// If null, the widget won't be wrapped in a flex.
  /// Defaults to null.
  final Axis? flexMainDirection;

  /// Main axis size of the flex. This does nothing if [flexmainDirection] is null.
  final MainAxisSize mainAxisSize;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsLabel}
  final String? semanticsLabel;

  /// {@macro flutter.progress_indicator.ProgressIndicator.semanticsValue}
  final String? semanticsValue;

  const MiniCircularProgressIndicator({
    Key? key,
    this.value,
    this.color,
    this.valueColor,
    this.padding,
    this.flexMainDirection,
    this.semanticsLabel,
    this.semanticsValue,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondary;

    final child = Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          height: 20,
          width: 20,
        ),
        child: CircularProgressIndicator(
          valueColor: valueColor ??
              AlwaysStoppedAnimation<Color>(
                color ?? secondaryColor,
              ),
          value: value,
          strokeWidth: 2.5,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        ),
      ),
    );

    if (flexMainDirection == null) return child;

    return Flex(
      direction: flexMainDirection!,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: mainAxisSize,
      children: [
        Flexible(
          flex: 0,
          child: child,
        ),
      ],
    );
  }
}
