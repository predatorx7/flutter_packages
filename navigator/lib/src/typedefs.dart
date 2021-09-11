import 'package:flutter/widgets.dart';

typedef RouteMatcherCallback = bool Function(RouteSettings? settings);

typedef PathWidgetBuilder = Widget Function(
  BuildContext context,
  RouteSettings settings,
);

typedef RouteBuilder = Route<dynamic>? Function({
  required WidgetBuilder builder,
  RouteSettings settings,
});

typedef RouteSettingsBuilder = RouteSettings? Function(
  RouteSettings settings,
);
