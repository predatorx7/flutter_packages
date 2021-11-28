import 'dart:async';

import 'package:app_boot/data/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_settings_manager.dart';

typedef DependencyObjectProviderCallback<T extends DependencyObject> = T
    Function(
  BuildContext context,
);

// ignore: use_key_in_widget_constructors
abstract class AnimatingSplash extends Widget {
  /// This completer indicates when the splash screen is done animating.
  Completer<bool> get animationCompleter;
}

/// A launch or splash screen that is shown while app is loading.
///
/// It is recommended to create your own LaunchScreen Widget that uses [LaunchScreen].
///
/// Use [AnimatingSplash] as [child] to inform the app that the splash UI is done animating.
class LaunchScreen<T extends DependencyObject> extends StatefulWidget {
  static const String routeName = '/';

  final String? routePath;

  /// The navigator will navigate to this path if [routePath] is null
  final String reRoutePath;
  final DependencyObjectProviderCallback<T> dependencyObjectProvider;

  /// A widget that is shown while [LaunchScreen] is loading. This represents splash screen's UI. This could be animating [AnimatingSplash].
  /// A constant widget instance might lead to better splash performance.
  final Widget child;

  final void Function(Object error, StackTrace stackTrace)? onError;

  const LaunchScreen({
    Key? key,
    required this.routePath,
    required this.reRoutePath,
    required this.dependencyObjectProvider,
    required this.child,
    this.onError,
  }) : super(key: key);

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
    await Future.wait(
      [
        onDependencyResolve(),
        onSplashScreenAnimating(),
      ],
    );

    Navigator.pushReplacementNamed(
      context,
      widget.routePath ?? widget.reRoutePath,
    );
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

  Future<void> onSplashScreenAnimating() async {
    final splash = widget.child;
    if (splash is AnimatingSplash && !splash.animationCompleter.isCompleted) {
      await splash.animationCompleter.future;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
