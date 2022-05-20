# Logging Manager for Flutter Projects

[![Pub:logging](https://img.shields.io/pub/v/logging_manager_flutter.svg)](https://pub.dev/packages/logging_manager_flutter)

Provides simple APIs for logging & managing logs. Logging manager with flutter support.

## Features

- Provides extension `FlutterLoggingManagerX` on the `LoggingManager` for flutter projects.
- This extension has `onFlutterError` method which can be capture flutter error.
- `listenErrorsWithCurrentIsolate` can be used to listen errors in the current isolate.
- `runFlutterInZoneGuardedWithLogging` can be used to log errors caught in the zone for flutter.

```dart
FlutterError.onError = loggingManager.onFlutterError;
```

## Get Started - Dependency setup 

Either add dependency in pubspec.yaml file
```yaml
    logging_manager_flutter: ^2.0.0
```

Or add dependency with
```yaml
    flutter pub add logging_manager_flutter
```

## Usage

1. Import this package in file.

```dart
import 'package:logging_manager_flutter/logging_manager_flutter.dart';
```

2. Create a LoggingManager, a class which is exported from `package:logging_manager_flutter`. 
Note: A LoggingTree is responsible for doing something with logs. If none provided, nothing will happen. 

```dart
final loggingManager = LoggingManager(
   logger: Logger('MyApp'),
   tree: PrintingColoredLogsTree(),
);
```

3. Optionally add flutter logging manager to record flutter errors.

```dart
FlutterError.onError = loggingManager.onFlutterError;
```

4. Create `package:logging`'s logger which is managed by the above manager.

```dart
final componentLogger = Logger('MyApp.componentName');
```

5. Use logger to log anything.

```dart
componentLogger.info('Hello World');
```

## Additional Information

For more usage see [Logging Manager package](https://pub.dev/packages/logging_manager).
