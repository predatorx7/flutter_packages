import 'package:flutter/widgets.dart';
import 'package:navigator/src/typedefs.dart';

import 'path.dart';

/// A factory to create a [NavigationPathInterface] to provide in list of paths to [RouterConfiguration].
///
/// Warning: Either pathName should not be null or isNavigationAllowed should be overriden.
abstract class NavigatableScreenFactory {
  @protected

  /// Builder to optionally create a [Route] to be navigated. Useful when builder is not enough and you need to create a [Route] with custom transitions.
  RouteBuilder? get routeBuilder;

  @protected
  String? get pathName => null;

  @protected

  /// This should not return true when [settings] is null.
  bool isNavigationAllowed(RouteSettings? settings) {
    return pathName == settings?.name;
  }

  bool get _isNavigatable {
    return pathName != null || isNavigationAllowed(null) != true;
  }

  @protected
  RouteSettings modifySettings(RouteSettings settings) => settings;

  NavigationPathInterface create() {
    assert(
      _isNavigatable,
      'For "$runtimeType" to be navigatable, either pathName should not be null or isNavigationAllowed should be overriden. isNavigationAllowed should not return true when settings is null.',
    );

    return NavigationPath(
      matcher: isNavigationAllowed,
      builder: onBuild,
      routeSettings: modifySettings,
      routeBuilder: routeBuilder,
    );
  }

  @protected

  /// Builds the primary contents of the route.
  Widget onBuild(BuildContext context, RouteSettings settings);
}
