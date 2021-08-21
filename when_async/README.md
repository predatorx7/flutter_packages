# when_async

Contains utility classes to work with asynchronous computations.

## Utilities

* [When.future][whenfuture_doc] for executing Futures with snapshots.
  - For futures, use [execute][when_execute] for one time execution. This only does the asynchronous future computation once and returns the same future's result in subsequent calls. To refresh the future again, use [refresh][when_refresh].
  - To get snapshots of the asynchronous computation's state instead, use [snapshots][when_snapshots]. To get refreshed snapshots, use [refreshSnapshots][when_refreshsnapshots]. 

## Usage

A simple usage example:

```dart
import 'package:when_async/when_async.dart';

main() {
  final _when = When.future<int>(
    () => Future.delayed(
      const Duration(seconds: 5),
      () => 1,
    ),
  );

  _when.execute(
    onLoading: () => stdout.writeln('Loading'),
    onComplete: (it) => stdout.writeln('$it'),
    onError: (e, s) => stdout.writeln('$e\n$s'),
    onFinally: () => stdout.writeln('Finally'),
  );

  // OR

  _when.snapshots((snapshot) { 
     stdout.writeln('Snapshot: ${snapshot.state}')
  });
}
```

Check [example.dart][example].

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/predatorx7/flutter_packages/issues
[example]: https://pub.dev/packages/when_async/example
[whenfuture_doc]: https://pub.dev/documentation/when_async/latest/when_async/When/future.html
[when_execute]: https://pub.dev/documentation/when_async/latest/when_async/When/execute.html
[when_refresh]: https://pub.dev/documentation/when_async/latest/when_async/When/refresh.html
[when_snapshots]: https://pub.dev/documentation/when_async/latest/when_async/When/snapshots.html
[when_refreshsnapshots]: https://pub.dev/documentation/when_async/latest/when_async/When/refreshSnapshots.html