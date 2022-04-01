import 'dart:async';

import 'package:app_boot/data/settings.dart';
import 'package:flutter/material.dart';

import '../app_settings_manager.dart';

typedef DependencyObjectProviderCallback<T extends DependencyObject> = T
    Function(
  BuildContext context,
);

enum AnimatingState {
  idle,
  animating,
}

class SplashAnimatingNotifier extends ValueNotifier<AnimatingState> {
  SplashAnimatingNotifier() : super(AnimatingState.idle);

  void onStarted() {
    _completer = Completer<bool>();
    value = AnimatingState.animating;
  }

  void onCompleted() {
    if (_completer == null) return;
    _completer!.complete(true);
    _completer = null;
    value = AnimatingState.idle;
  }

  void onCancelled() {
    if (_completer == null) return;
    _completer!.complete(false);
    _completer = null;
    value = AnimatingState.idle;
  }

  bool get isAnimating => value == AnimatingState.animating;
  Completer<bool>? _completer;

  Future<bool> waitForChange() {
    if (_completer == null) {
      return Future.value(true);
    }
    return _completer!.future;
  }

  @override
  void dispose() {
    _completer?.complete(false);
    _completer = null;
    super.dispose();
  }
}

/// A launch or splash screen that is shown while app is loading.
///
/// It is recommended to create your own LaunchScreen Widget that uses [LaunchScreen].
///
/// Use [AnimatingSplash] as [child] to inform the app that the splash UI is done animating.
class LaunchScreen extends StatefulWidget {
  static const String routeName = '/';

  final String? routePath;

  /// The navigator will navigate to this path if [routePath] is null
  final String reRoutePath;
  final DependencyObjectProviderCallback<DependencyObject> dependencyObjectProvider;

  /// A widget that is shown while [LaunchScreen] is loading. This represents splash screen's UI. This could be animating [AnimatingSplash].
  /// A constant widget instance might lead to better splash performance.
  final Widget child;

  final SplashAnimatingNotifier? animatingNotifier;

  final void Function(
    Object error,
    StackTrace stackTrace,
  )? onError;

  final Future<void> Function(
    BuildContext context,
    String routeName,
  ) onNavigate;

  const LaunchScreen({
    Key? key,
    required this.routePath,
    required this.reRoutePath,
    required this.dependencyObjectProvider,
    required this.child,
    this.onNavigate = _onNavigateDefault,
    this.onError,
    this.animatingNotifier,
  }) : super(key: key);

  static Future<void> _onNavigateDefault(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
    );
  }

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(onInitialized);
  }

  static final Completer<void> _completer = Completer<void>();

  Future<void> onInitialized() async {
    bool _canNavigate = true;
    await Future.wait(
      [
        onDependencyResolve(),
        onSplashScreenAnimating().then((value) {
          _canNavigate = value;
        }),
      ],
    );

    if (_canNavigate) {
      widget.onNavigate(
        context,
        widget.routePath ?? widget.reRoutePath,
      );
    }
  }

  Future<void> onDependencyResolve() async {
    if (!_completer.isCompleted) {
      try {
        await currentSettings.dependencies?.call(
          widget.dependencyObjectProvider(context),
        );
        _completer.complete();
      } catch (e, s) {
        widget.onError?.call(e, s);
      }
    }
  }

  Future<bool> onSplashScreenAnimating() {
    if (widget.animatingNotifier?.isAnimating == true) {
      return widget.animatingNotifier!.waitForChange();
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
