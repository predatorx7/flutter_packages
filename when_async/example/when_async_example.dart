import 'dart:io';

import 'package:when_async/when_async.dart';

void main() {
  final _when = When.future<int>(
    Future.delayed(
      const Duration(seconds: 5),
      () => 1,
    ),
  );

  int _index = 0;

  _when.execute(
    onLoading: () => stdout.writeln('$_index: Loading'),
    onComplete: (it) => stdout.writeln('$_index: $it'),
    onError: (e, s) => stdout.writeln('$_index: $e\n$s'),
    onFinally: () => stdout.writeln('$_index: Finally'),
  );

  _index = 1;

  _when.execute(
    onLoading: () => stdout.writeln('$_index: Loading'),
    onComplete: (it) => stdout.writeln('$_index: Data: $it'),
    onError: (e, s) => stdout.writeln('$_index: Error: $e\n$s'),
    onFinally: () => stdout.writeln('$_index: Finally'),
  );
}
