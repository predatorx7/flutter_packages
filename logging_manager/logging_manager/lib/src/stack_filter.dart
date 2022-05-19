// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'stack_frame.dart';

/// A class that filters stack frames for additional filtering on
/// [FlutterError.defaultStackFilter].
abstract class StackFilter {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const StackFilter();

  /// Filters the list of [StackFrame]s by updating corresponding indices in
  /// `reasons`.
  ///
  /// To elide a frame or number of frames, set the string.
  void filter(List<StackFrame> stackFrames, List<String?> reasons);
}

class StackFilterContainer {
  StackFilterContainer._();

  static final List<StackFilter> _stackFilters = <StackFilter>[];

  /// Adds a stack filtering function to [defaultStackFilter].
  ///
  /// For example, the framework adds common patterns of element building to
  /// elide tree-walking patterns in the stacktrace.
  ///
  /// Added filters are checked in order of addition. The first matching filter
  /// wins, and subsequent filters will not be checked.
  static void addDefaultStackFilter(StackFilter filter) {
    _stackFilters.add(filter);
  }

  /// Converts a stack to a string that is more readable by omitting stack
  /// frames that correspond to Dart internals.
  ///
  /// This is the default filter used by [dumpErrorToConsole] if the
  /// [FlutterErrorDetails] object has no [FlutterErrorDetails.stackFilter]
  /// callback.
  ///
  /// This function expects its input to be in the format used by
  /// [StackTrace.toString()]. The output of this function is similar to that
  /// format but the frame numbers will not be consecutive (frames are elided)
  /// and the final line may be prose rather than a stack frame.
  static Iterable<String> defaultStackFilter(Iterable<String> frames) {
    final Map<String, int> removedPackagesAndClasses = <String, int>{
      'dart:async-patch': 0,
      'dart:async': 0,
      'package:stack_trace': 0,
      'class _AssertionError': 0,
      'class _FakeAsync': 0,
      'class _FrameCallbackEntry': 0,
      'class _Timer': 0,
      'class _RawReceivePortImpl': 0,
      'package:logging_manager': 0,
      'package:logging': 0,
    };

    int skipped = 0;

    final List<StackFrame> parsedFrames =
        StackFrame.fromStackString(frames.join('\n'));

    for (int index = 0; index < parsedFrames.length; index += 1) {
      final StackFrame frame = parsedFrames[index];
      final String className = 'class ${frame.className}';
      final String package = '${frame.packageScheme}:${frame.package}';
      if (removedPackagesAndClasses.containsKey(className)) {
        skipped += 1;
        removedPackagesAndClasses.update(className, (int value) => value + 1);
        parsedFrames.removeAt(index);
        index -= 1;
      } else if (removedPackagesAndClasses.containsKey(package)) {
        skipped += 1;
        removedPackagesAndClasses.update(package, (int value) => value + 1);
        parsedFrames.removeAt(index);
        index -= 1;
      }
    }
    final List<String?> reasons =
        List<String?>.filled(parsedFrames.length, null);
    for (final StackFilter filter in _stackFilters) {
      filter.filter(parsedFrames, reasons);
    }

    final List<String> result = <String>[];

    // Collapse duplicated reasons.
    for (int index = 0; index < parsedFrames.length; index += 1) {
      final int start = index;
      while (index < reasons.length - 1 &&
          reasons[index] != null &&
          reasons[index + 1] == reasons[index]) {
        index++;
      }
      String suffix = '';
      if (reasons[index] != null) {
        if (index != start) {
          suffix = ' (${index - start + 2} frames)';
        } else {
          suffix = ' (1 frame)';
        }
      }
      final String resultLine =
          '${reasons[index] ?? parsedFrames[index].source}$suffix';
      result.add(resultLine);
    }

    // Only include packages we actually elided from.
    final List<String> where = <String>[
      for (MapEntry<String, int> entry in removedPackagesAndClasses.entries)
        if (entry.value > 0) entry.key,
    ]..sort();
    if (skipped == 1) {
      result.add('(elided one frame from ${where.single})');
    } else if (skipped > 1) {
      if (where.length > 1) where[where.length - 1] = 'and ${where.last}';
      if (where.length > 2) {
        result.add('(elided $skipped frames from ${where.join(", ")})');
      } else {
        result.add('(elided $skipped frames from ${where.join(" ")})');
      }
    }
    return result;
  }
}
