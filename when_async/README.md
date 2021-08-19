# when_async

APIs for easy consumption of asynchronous computations

## Usage

A simple usage example:

```dart
import 'package:when_async/when_async.dart';

main() {
  final _when = When.future<int>(
    Future.delayed(
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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
