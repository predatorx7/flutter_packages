import 'package:flutter/cupertino.dart' hide Path;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Path;

import 'package:navigator/src/logger.dart';

import 'page_route.dart';
import 'path.dart';

class RouteConfiguration {
  /// List of [NavigationPath] for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [NavigationPath.matcher]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  final List<NavigationPath> paths;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  RouteConfiguration(
    this.paths,
  );

  Route<dynamic>? _lastGeneratedRoute;

  Route<dynamic>? get lastGeneratedRoute => _lastGeneratedRoute;

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    logger.log(
      'route: ${settings.name}, args: ${settings.arguments.runtimeType}(${settings.arguments})',
    );

    for (final path in paths) {
      final hasMatch = path.matcher(settings);

      if (hasMatch) {
        Widget _builder(BuildContext context) {
          return path.builder(context, settings);
        }

        final _routeSettings = path.routeSettings?.call(settings) ?? settings;

        if (path.routeBuilder != null) {
          _lastGeneratedRoute = path.routeBuilder!(
            builder: _builder,
            settings: _routeSettings,
          );

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
    }

    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return null;
  }

  Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    logger.log(
      'Unknown route encountered with name: ${settings.name}, args: ${settings.arguments.runtimeType}(${settings.arguments})',
    );

    if (settings.name == '/') {
      throw UnimplementedError('A route with path name "/" must exist.');
    }

    final _rootSettings = settings.copyWith(name: '/');

    return onGenerateRoute(_rootSettings);
  }
}
