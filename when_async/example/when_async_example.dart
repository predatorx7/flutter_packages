import 'dart:io';

import 'package:when_async/when_async.dart';

class FakeError extends Error {}

Future<void> example1() {
  stdout.writeln('Example 1');

  final _when = When.future<int>(
    () => Future.delayed(
      const Duration(seconds: 5),
      () => 1,
    ),
  );

  final _whenError = When.future<int>(
    () => Future.delayed(
      const Duration(seconds: 5),
      () => throw FakeError(),
    ),
  );

  const _listener1 = '(execute)';

  final task1 = _when.execute(
    onLoading: () => stdout.writeln('$_listener1: Loading'),
    onComplete: (it) => stdout.writeln('$_listener1: Data: $it'),
    onError: (e, s) => stdout.writeln('$_listener1: $e'),
    onFinally: () => stdout.writeln('$_listener1: Finally'),
  );

  const _listener2 = '(executeWithError)';

  final task2 = _whenError.execute(
    onLoading: () => stdout.writeln('$_listener2: Loading'),
    onComplete: (it) => stdout.writeln('$_listener2: Data: $it'),
    onError: (e, s) => stdout.writeln('$_listener2: Error: $e'),
    onFinally: () => stdout.writeln('$_listener2: Finally'),
  );

  return Future.wait([task1, task2]);
}

Future<void> example2() {
  stdout.writeln('Example 2');

  final _when = When.future<int>(
    () => Future.delayed(
      const Duration(seconds: 5),
      () => 1,
    ),
  );

  final _whenError = When.future<int>(
    () => Future.delayed(
      const Duration(seconds: 5),
      () => throw FakeError(),
    ),
  );

  const _listener1 = '(snapshot)';

  final task1 = _when.snapshots(
    (snapshot) => stdout.writeln('$_listener1: ${snapshot.state}'),
    () => stdout.writeln('$_listener1: Finally'),
  );

  const _listener2 = '(snapshotWithError)';

  final task2 = _whenError.snapshots(
    (snapshot) => stdout.writeln('$_listener2: ${snapshot.state}'),
    () => stdout.writeln('$_listener2: Finally'),
  );

  return Future.wait([task1, task2]);
}

Future<void> main() async {
  await example1();
  await example2();
}
