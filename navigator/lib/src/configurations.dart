import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Path;
import 'package:navigator/src/link_navigation.dart';

import 'package:navigator/src/logger.dart';
import 'package:navigator/src/typedefs.dart';

import 'page_route.dart';
import 'path.dart';

/// A configuration of router that can be use for easy & powerful navigations.
///
/// To use this for navigation, add instance of this to your `MaterialApp`
///
/// ```dart
/// child: MaterialApp(
///     // ...
///     navigatorKey: navigationProvider.navigatorKey,
///     onGenerateRoute: navigationProvider.onGenerateRoute,
///     onUnknownRoute: navigationProvider.onUnknownRoute,
///     // ...
/// ),
/// ```
class RouterConfiguration with LinkRouter {
  /// Creates a route configuration with paths for navigation.
  RouterConfiguration({
    required this.paths,
    GlobalKey<NavigatorState>? navigatorKey,
    List<NamedPath>? namedPaths,
    this.linkNavigator,
    NavigatorLogger? logger,
    this.routeBuilder,
  })  : logger = logger ?? NavigatorLogger(),
        navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        namedPathsMap = _createNamedPaths(namedPaths);

  /// A logger for logging navigation requests and issues.
  final NavigatorLogger logger;

  /// A common route builder for all routes. Used when [NavigationPath.routeBuilder] is null.
  /// If this value is null, then fallbacks to [NoAnimationMaterialPageRoute] on web and [MaterialPageRoute] for others.
  final RouteBuilder? routeBuilder;

  /// List of [NavigationPath] for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [NavigationPath.matcher]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  List<NavigationPathInterface> paths;

  /// List of [NamedPath] for route matching converted to a map of [String] to [NamedPath]. When a named route is pushed with
  /// [Navigator.pushNamed], the route name from settings is used to match with [NamedPath.pathName] from this map to
  /// retrieve builder.
  ///
  /// If builder is not null, then it will be used to create a route.
  final Map<String, NamedPath> namedPathsMap;

  /// A key to use when building the [Navigator]. Usually a reference to [MaterialApp.navigatorKey].
  ///
  /// Used by this to directly manipulate the [Navigator] without first obtaining [NavigatorState] from a [BuildContext] via [Navigator.of].
  final GlobalKey<NavigatorState> navigatorKey;

  @protected
  @override
  NavigatorState? get navigatorState => navigatorKey.currentState;

  @override
  @protected

  /// This is responsible for responding to navigation requests made from
  /// [RouterConfiguration.navigateFromUri].
  ///
  /// You can create your custom implementations for this or use [LinkNavigator].
  final LinkNavigatorInterface? linkNavigator;

  static Map<String, NamedPath> _createNamedPaths(List<NamedPath>? namedPaths) {
    final _paths = <String, NamedPath>{};
    if (namedPaths != null) {
      for (final path in namedPaths) {
        _paths[path.pathName] = path;
      }
    }
    return Map.unmodifiable(_paths);
  }

  Route<dynamic>? _lastGeneratedRoute;

  @override

  /// Last route that was created from this [RouterConfiguration.onGenerateRoute].
  Route<dynamic>? get lastGeneratedRoute => _lastGeneratedRoute;

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    logger.log(
      'route: ${settings.name}, args: ${settings.arguments.runtimeType}(${settings.arguments})',
    );

    final _namedNavigationPath = namedPathsMap[settings.name];

    if (_namedNavigationPath != null) {
      final _route = _createRoute(_namedNavigationPath, settings);
      _lastGeneratedRoute = _route;
      return _route;
    }

    for (final path in paths) {
      final hasMatch = path.matcher(settings);

      if (hasMatch) {
        return _createRoute(path, settings);
      }
    }

    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return null;
  }

  Route<dynamic>? _createRoute<T extends NavigationPathInterface>(
    T path,
    RouteSettings settings,
  ) {
    Widget _builder(BuildContext context) {
      return path.builder(context, settings);
    }

    final _routeSettings = path.routeSettings?.call(settings) ?? settings;

    final _routeBuilder = path.routeBuilder ?? routeBuilder;
    if (_routeBuilder != null) {
      _lastGeneratedRoute = _routeBuilder(
        _builder,
        _routeSettings,
      );

      // TODO: If route builder returns null, then it means that for some reason, this builder does not want to build routes,
      // so we must reject this navigation somehow.
      if (_lastGeneratedRoute != null) return _lastGeneratedRoute;
    }

    if (kIsWeb) {
      _lastGeneratedRoute = NoAnimationMaterialPageRoute<void>(
        builder: _builder,
        settings: _routeSettings,
      );
    } else {
      _lastGeneratedRoute = MaterialPageRoute<void>(
        builder: _builder,
        settings: _routeSettings,
      );
    }

    return _lastGeneratedRoute;
  }

  Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    logger.log(
      'Unknown route encountered with name: ${settings.name}, args: ${settings.arguments.runtimeType}(${settings.arguments})',
    );

    if (settings.name == '/') {
      throw UnimplementedError('A route with path name "/" must exist.');
    }

    final _rootSettings = RouteSettings(name: '/', arguments: settings.arguments,);

    return onGenerateRoute(_rootSettings);
  }
}
