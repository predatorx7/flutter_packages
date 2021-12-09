# Logging Manager

[![Pub:logging](https://img.shields.io/pub/v/logging_manager.svg)](https://pub.dev/packages/logging_manager)

Provides simple APIs for logging & managing logs. Uses the logger from [pub.dev:logging](https://pub.dev/packages/logging).

If using flutter, import [pub.dev:logging_manager_flutter](https://pub.dev/packages/logging_manager_flutter) instead.

## Features

- `LoggingTree` is attached as a listener to logs sent from logger by the `LoggingManager`. Implementations are: PrintingColoredLogsTree, PrintingLogsTree, FormattedOutputLogsTree.
- `LoggingManager` can be used to create a logger, listen to logs, change `LoggingTree`s.



## Getting started

Start by importing this package in your project using

### For Dart
```shell
dart pub add logging_manager
```

### For Flutter
```shell
flutter pub add logging_manager
```

### With Pub
```shell
pub add logging_manager
```

## Usage

1. Import this package in file.

```
import 'package:logging_manager/logging_manager.dart';
```

2. Create a LoggingManager. Note: A LoggingTree is responsible for doing something with logs. If none provided, nothing will happen.

```dart
final logginManager = LoggingManager(
   tree: PrintingColoredLogsTree(),
);
```

3. Get `package:logging`'s logger from above manager.

```dart
final logger = logginManager.root;
```

4. Use to log anything.

```dart
logger.info('Hello World');
```

## Additional information

For more information about using the logger, check [pub.dev:logging](https://pub.dev/packages/logging).