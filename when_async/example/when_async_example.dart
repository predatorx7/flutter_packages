import 'dart:io';

import 'package:when_async/when_async.dart';

void example1() {
  final _when = When.future<int>(
    () => Future.delayed(
      const Duration(seconds: 5),
      () => 1,
    ),
  );

  const _listener1 = '(0)';

  _when.execute(
    onLoading: () => stdout.writeln('$_listener1: Loading'),
    onComplete: (it) => stdout.writeln('$_listener1: Data: $it'),
    onError: (e, s) => stdout.writeln('$_listener1: $e\n$s'),
    onFinally: () => stdout.writeln('$_listener1: Finally'),
  );

  const _listener2 = '(1)';

  _when.execute(
    onLoading: () => stdout.writeln('$_listener2: Loading'),
    onComplete: (it) => stdout.writeln('$_listener2: Data: $it'),
    onError: (e, s) => stdout.writeln('$_listener2: Error: $e\n$s'),
    onFinally: () => stdout.writeln('$_listener2: Finally'),
  );
}

void example2() {
  final _when = When.future<int>(
    () => Future.delayed(
      const Duration(seconds: 5),
      () => 1,
    ),
  );

  const _listener1 = '(0)';

  _when.snapshots(
    (snapshot) => stdout.writeln('$_listener1: ${snapshot.state}'),
    () => stdout.writeln('$_listener1: Finally'),
  );

  const _listener2 = '(1)';

  _when.snapshots(
    (snapshot) => stdout.writeln('$_listener2: ${snapshot.state}'),
    () => stdout.writeln('$_listener1: Finally'),
  );
}

void main() {
  example2();
  example2();
}
