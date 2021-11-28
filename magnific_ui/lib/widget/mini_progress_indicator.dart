import 'package:flutter/material.dart';

class MiniCircularProgressIndicator extends StatelessWidget {
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const MiniCircularProgressIndicator({
    Key? key,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _secondaryColor = _theme.colorScheme.secondary;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 14.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          height: 20,
          width: 20,
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? _secondaryColor),
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}
