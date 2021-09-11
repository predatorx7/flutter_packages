import 'package:flutter/foundation.dart';

import 'typedefs.dart';

/// An immutable object that represents a path for navigation. When a named route is pushed with
/// [Navigator.pushNamed], the route name is matched with the [NavigationPath.matcher].
///
/// If there is a match with this, then this [builder] will be returned for construction of primary widgets of a route.
///
/// Example:
///
/// ```dart
/// NavigationPath(
///  matcher: (route) => route?.name == ProfileAndMore.route,
///  builder: (_, __) {
///    return const Example();
///  },
/// ),
/// ```
@immutable
class NavigationPath {
  /// When a named route is pushed with [Navigator.pushNamed],
  /// the route name is matched using this matcher.
  final RouteMatcherCallback matcher;

  /// Builds the primary contents of the route.
  final PathWidgetBuilder builder;

  /// An builter to optional create/modify data that might be useful in constructing a [Route].
  final RouteSettingsBuilder? routeSettings;

  /// Builder to optionally create a [Route] to be navigated. Useful when builder is not enough and you need to create a [Route] with custom transitions.
  final RouteBuilder? routeBuilder;

  const NavigationPath({
    required this.matcher,
    required this.builder,
    this.routeSettings,
    this.routeBuilder,
  });
}
