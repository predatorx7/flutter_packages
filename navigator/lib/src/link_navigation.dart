import 'package:flutter/widgets.dart';
import 'configurations.dart' show RouterConfiguration;
import 'error.dart';

/// This is responsible for responding to navigation requests made from
/// [LinkRouter.navigateFromUri] or [RouterConfiguration.navigateFromUri].
///
/// Implemented by [LinkNavigator].
mixin LinkNavigatorInterface {
  /// This is called for executing a navigation when some component calls
  /// [LinkRouter.navigateFromUri] or [RouterConfiguration.navigateFromUri].
  ///
  /// The [data]'s [LinkRouterData.navigatorState] should be used for executing
  /// navigations as a response of navigation request for [link].
  Future<void> navigate(
    Uri link,
    LinkRouterData data,
  );
}

typedef NavigateOnLinkCallback = Future<void> Function(
  Uri link,
  LinkRouterData data,
);

class LinkNavigator with LinkNavigatorInterface {
  const LinkNavigator(this.onNavigationRequest);

  final NavigateOnLinkCallback onNavigationRequest;

  @override
  Future<void> navigate(
    Uri link,
    LinkRouterData data,
  ) {
    return onNavigationRequest(link, data);
  }
}

@immutable
class LinkRouterData {
  /// Last route that was created from [RouterConfiguration.onGenerateRoute].
  final Route<dynamic>? lastGeneratedRoute;
  final NavigatorState navigatorState;

  const LinkRouterData({
    required this.navigatorState,
    required this.lastGeneratedRoute,
  });
}

/// External components can use instance of [LinkRouter]
/// to create navigation callbacks from urls as [Uri]s or [String]s.
///
/// [RouterConfiguration] implements [LinkRouter].
mixin LinkRouter {
  @protected
  LinkNavigatorInterface? get linkNavigator;

  @protected
  NavigatorState? get navigatorState;

  Route<dynamic>? get lastGeneratedRoute;

  void navigateFromUri(Uri uri) async {
    assert(linkNavigator != null);
    try {
      final _navigatorState = navigatorState;
      if (_navigatorState == null) {
        throw const NavigationError('navigatorState is null');
      }
      await linkNavigator?.navigate(
        uri,
        LinkRouterData(
          navigatorState: _navigatorState,
          lastGeneratedRoute: lastGeneratedRoute,
        ),
      );
    } catch (e, s) {
      throw NavigationError('Navigation failure', e, s);
    }
  }

  void navigateFromString(String link) {
    return navigateFromUri(Uri.parse(link));
  }
}
