import 'package:flutter/material.dart' show Colors, Color;

Color blendOverlayWithSurface(
  Color overlay, {
  Color surface = Colors.white,
  double fraction = 0.93,
}) {
  return Color.lerp(surface, overlay, fraction)!;
}
