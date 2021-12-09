import 'package:flutter/widgets.dart';

import 'error.dart';

typedef NavigateOnLinkCallback = Future<void> Function(
  Uri link,
  NavigatorState navigatorState,
);

abstract class LinkNavigatorInterface {
  Future<void> navigate(
    Uri link,
    NavigatorState navigatorState,
  );
}

class LinkNavigator implements LinkNavigatorInterface {
  const LinkNavigator(this.onNavigationRequest);

  final NavigateOnLinkCallback onNavigationRequest;

  @override
  Future<void> navigate(
    Uri link,
    NavigatorState navigatorState,
  ) {
    return onNavigationRequest(link, navigatorState);
  }
}

mixin LinkRouter {
  @protected
  LinkNavigator? get linkNavigator;

  @protected
  NavigatorState? get navigatorState;

  void navigateFromLink(Uri uri) async {
    assert(linkNavigator != null);
    try {
      final _navigatorState = navigatorState;
      if (_navigatorState == null) {
        throw const NavigationError('navigatorState is null');
      }
      await linkNavigator?.navigate(uri, _navigatorState);
    } catch (e, s) {
      throw NavigationError('Navigation failure', e, s);
    }
  }
}
