# Navigator

[![pub package](https://img.shields.io/pub/v/navigator?style=flat-square)](https://pub.dev/packages/navigator)

An easy yet powerful navigator for simple flutter apps.

## Features

- Easy to integrate & easy to use
- Uses Flutter's Navigator v1.0
- Supports deeplinking and routing from external components
- Doesn't use magic

## Getting started

Add this package as a dependency

```shell
flutter pub add navigator
```

Import this package in your file
```dart
import 'package:navigator/navigator.dart';
```

## Usage

### Setup

1. Create a `List<NavigationPath>`
```dart
final navigationPaths = [
    NamedPath(
      pathName: AppLaunchScreen.routeName,
      builder: (_, settings) {
        final redirectionPathName = getValueIfTypeMatched<String>(
          settings.arguments,
        );

        return AppLaunchScreen(
          routePath: redirectionPathName,
          reRoutePath: HomeScreen.route,
        );
      },
    ),
    NamedPath(
      pathName: HomeScreen.routeName,
      builder: (_, __) => const HomeScreen(),
    ),
    NavigationPath(
      matcher: (route) =>
          route?.name?.startsWith('${MovieDetailsScreen.route}/') ?? false,
      builder: (_, settings) {
        return MovieDetailsScreen();
      },
    ),
];
```

2. Create a router configuration with a list of `NavigationPath`.

```dart
final navigationProvider = RouterConfiguration(
    paths,
);
```

### Install

2.1. Add router configuration to your `MaterialApp`

```dart
child: MaterialApp(
    // ...
    navigatorKey: navigationProvider.navigatorKey,
    onGenerateRoute: navigationProvider.onGenerateRoute,
    onUnknownRoute: navigationProvider.onUnknownRoute,
    // ...    
),
```

## More

### Provide

You can _optionally_ use your favorite dependency injection framework for providing `List<NavigationPath>` & `RouterConfiguration` to `MaterialApp`. (Riverpod is used in the below example).

```dart
final navigationProvider = Provider((ref) {
  final paths = ref.read(navigationPaths);

  return RouterConfiguration(
    paths,
  );
});

final navigationPaths = Provider<List<NavigationPath>>((ref) {
  return [
    NavigationPath(
      matcher: (route) => route?.name == AppLaunchScreen.routeName,
      builder: (_, settings) {
        final pathName = getValueIfTypeMatched<String>(
          settings.arguments,
        );

        return AppLaunchScreen(
          routePath: pathName,
          reRoutePath: HomeScreen.route,
        );
      },
    ),
    NamedPath(
      pathName: UnverifiedAppScreen.routeName,
      builder: (_, __) => const UnverifiedAppScreen(),
    ),
    NavigationPath(
      matcher: (route) =>
          route?.name?.startsWith('${MovieDetailsScreen.route}/') ?? false,
      builder: (_, settings) {
        return MovieDetailsScreen();
      },
    ),
  ];
});
```

```dart
final _nav = ref.read(navigationProvider);

// ...
child: MaterialApp(
    // ...
    navigatorKey: _nav.navigatorKey,
    onGenerateRoute: _nav.onGenerateRoute,
    onUnknownRoute: _nav.onUnknownRoute,
    // ...    
),
```

### Context-less navigation

Use can use navigatorState from `RouterConfiguration`'s instance for navigation without context: `RouterConfiguration.navigatorState`.

### Function & Working

1. This package heavily relies on `MaterialApp.onGenerateRoute`.
2. Upon navigation from `Navigator.of(context).*`, RouterConfiguration checks `RouteSettings.name` in `RouterConfiguration.namedPathsMap` first. If the result is not null, `NamedPath.builder` is used to create a route.
3. If result is null from `namedPathsMap`, `RouterConfiguration` iteratively runs `NavigationPath.matcher` for every `NavigationPath` in `RouterConfiguration.paths`. 
4. Upon first match, `NavigationPath.builder` is used to create a route.
5. This also means that paths with lower index in the list `RouterConfiguration.paths` has higher precedence.

### Default Behaviours

1. By default, `NoAnimationMaterialPageRoute` when creating a route for web platform and `MaterialPageRoute` is used for route creation for all other platforms. This behaviour can be overriden by using `NavigationPath.routeBuilder` for providing a custom `PageRoute` from a builder callback.

#### Upcoming

- Navigator v2.0 support.

Please report any issues or improvements on this project's [Issues Tracker](https://github.com/predatorx7/flutter_packages/issues).
