import 'package:flutter/widgets.dart';

import 'error.dart';

typedef NavigateOnLinkCallback = Future<void> Function(
  Uri link,
  LinkRouterData data,
);

abstract class LinkNavigatorInterface {
  Future<void> navigate(
    Uri link,
    LinkRouterData data,
  );
}

class LinkNavigator implements LinkNavigatorInterface {
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
  final Route<dynamic>? lastGeneratedRoute;
  final NavigatorState navigatorState;

  const LinkRouterData({
    required this.navigatorState,
    required this.lastGeneratedRoute,
  });
}

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
