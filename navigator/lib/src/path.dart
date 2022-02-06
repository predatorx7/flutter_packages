import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BuildContext, RouteSettings, Widget;

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

  NavigationPath copyWith({
    RouteMatcherCallback? matcher,
    PathWidgetBuilder? builder,
    RouteSettingsBuilder? routeSettings,
    RouteBuilder? routeBuilder,
  }) {
    return NavigationPath(
      matcher: matcher ?? this.matcher,
      builder: builder ?? this.builder,
      routeSettings: routeSettings ?? this.routeSettings,
      routeBuilder: routeBuilder ?? this.routeBuilder,
    );
  }
}

/// A navigation path that is used to navigate to a named route.
class NamedPath extends NavigationPath {
  NamedPath({
    required this.pathName,
    required PathWidgetBuilder builder,
    RouteSettingsBuilder? routeSettings,
    RouteBuilder? routeBuilder,
  }) : super(
          matcher: (settings) => settings?.name == pathName,
          builder: builder,
          routeSettings: routeSettings,
          routeBuilder: routeBuilder,
        );

  final String pathName;

  @override
  NavigationPath copyWith({
    String? pathName,
    RouteMatcherCallback? matcher,
    PathWidgetBuilder? builder,
    RouteSettingsBuilder? routeSettings,
    RouteBuilder? routeBuilder,
  }) {
    final RouteMatcherCallback _matcher = matcher ??
        (pathName != null ? (settings) => settings?.name == pathName : null) ??
        this.matcher;

    return super.copyWith(
      matcher: _matcher,
      builder: builder ?? this.builder,
      routeSettings: routeSettings ?? this.routeSettings,
      routeBuilder: routeBuilder ?? this.routeBuilder,
    );
  }
}

/// Works only if argument is of type [ScreenBuilder].
class TypeNavigationPath<T extends Widget> extends NavigationPath {
  TypeNavigationPath({
    RouteSettingsBuilder? routeSettings,
    RouteBuilder? routeBuilder,
  }) : super(
          matcher: (settings) => settings?.arguments is ScreenBuilder<T>,
          builder: _pathWidgetBuilder,
          routeSettings: routeSettings,
          routeBuilder: routeBuilder,
        );

  static Widget _pathWidgetBuilder(
    BuildContext context,
    RouteSettings settings,
  ) {
    return (settings.arguments as ScreenBuilder).screenBuilder(
      context,
      settings,
    );
  }
}

typedef ScreenBuilderCallback<T extends Widget> = T Function(
  BuildContext context,
  RouteSettings settings,
);

/// Data that might be useful in constructing a [Widget] screen.
@immutable
class ScreenBuilder<T extends Widget> {
  /// Creates data used to construct screens.
  const ScreenBuilder({
    required this.screenBuilder,
  });

  /// Creates a copy of this screen builder object with the given fields
  /// replaced with the new values.
  ScreenBuilder<T> copyWith({
    String? name,
    Object? arguments,
    ScreenBuilderCallback<T>? screenBuilder,
  }) {
    return ScreenBuilder<T>(
      screenBuilder: screenBuilder ?? this.screenBuilder,
    );
  }

  final ScreenBuilderCallback<T> screenBuilder;
}
