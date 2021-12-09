# Logging Manager for Flutter Projects

[![Pub:logging](https://img.shields.io/pub/v/logging_manager_flutter.svg)](https://pub.dev/packages/logging_manager_flutter)

Provides simple APIs for logging & managing logs. Logging manager with flutter support.

## Features

- Provides `FlutterLoggingManager` as a replacement for LoggingManager for flutter projects.
- `FlutterLoggingManager` has `onFlutterError` method which can be capture flutter error.
```dart
FlutterError.onError = loggingManager.onFlutterError;
```

## Get Started - Dependency setup 

Either add dependency in pubspec.yaml file
```yaml
    logging_manager_flutter: ^1.0.0
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

2. Create a FlutterLoggingManager. Note: A LoggingTree is responsible for doing something with logs. If none provided, nothing will happen.

```dart
final loggingManager = FlutterLoggingManager(
   tree: PrintingColoredLogsTree(),
);
```

3. Optionally add flutter logging manager to record flutter errors.

```dart
FlutterError.onError = loggingManager.onFlutterError;
```

4. Get `package:logging`'s logger from above manager.

```dart
final appLogger = loggingManager.logger;
```

5. Use logger to log anything.

```dart
appLogger.info('Hello World');
```

## Additional Information

For more usage see [Logging Manager package](https://pub.dev/packages/logging_manager).

