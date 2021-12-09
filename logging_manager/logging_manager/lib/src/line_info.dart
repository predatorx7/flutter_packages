import 'package:logging/logging.dart';

/// Log Line Information.
/// Used when extracting tag and attaching log line number value.
class LogLineInfo {
  static const _defaultTag = 'Dart';

  /// Tag extracted from stacktrace (usually class)
  String tag;

  /// Log file path.
  String? logFilePath;

  /// Line number of the log line.
  int lineNumber;

  /// Character at the log line.
  int characterIndex;

  static StackTrace getAssociatedStackTrace(LogRecord? record) {
    return record?.stackTrace ?? StackTrace.current;
  }

  /// Creates LogLineInfo instance.
  LogLineInfo({
    required this.tag,
    this.logFilePath,
    this.lineNumber = 0,
    this.characterIndex = 0,
  });

  static final _logMatcher = RegExp(
    r"([a-zA-Z\<\>\s\.]*)\s\(file:\/(.*\.dart):(\d*):(\d*)",
  );

  /// Gets [LogLineInfo] with [stackIndex]
  /// which provides data for tag and line of code
  factory LogLineInfo.get({
    int stackIndex = 4,
    LogRecord? record,
  }) {
    ///([a-zA-Z\<\>\s\.]*)\s\(file:\/(.*\.dart):(\d*):(\d*)
    /// group 1 = tag
    /// group 2 = filepath
    /// group 3 = line number
    /// group 4 = column
    /// "#4      main.<anonymous closure>.<anonymous closure> (file:///Users/magillus/Projects/opensource/flutter-fimber/fimber/test/fimber_test.dart:19:14)"
    var stackTraceList = getAssociatedStackTrace(record).toString().split('\n');
    if (stackTraceList.length > stackIndex) {
      var logline = stackTraceList[stackIndex];
      final matches = _logMatcher.allMatches(logline);

      if (matches.isNotEmpty) {
        final match = matches.first;
        return LogLineInfo(
          tag: match
                  .group(1)
                  ?.trim()
                  .replaceAll("<anonymous closure>", "<ac>") ??
              _defaultTag,
          logFilePath: match.group(2),
          lineNumber: int.tryParse(match.group(3) ?? '-1') ?? -1,
          characterIndex: int.tryParse(match.group(4) ?? '-1') ?? -1,
        );
      } else {
        return LogLineInfo(tag: _defaultTag);
      }
    } else {
      return LogLineInfo(tag: _defaultTag);
    }
  }

  /// Gets tag with [stackIndex],
  /// how many steps in stacktrace should be taken to grab log call.
  static String getTag({
    int stackIndex = 4,
    LogRecord? record,
  }) {
    var stackTraceList = getAssociatedStackTrace(record).toString().split('\n');
    if (stackTraceList.length > stackIndex) {
      var lineChunks =
          stackTraceList[stackIndex].replaceAll("<anonymous closure>", "<ac>");
      if (lineChunks.length > 6) {
        var lineParts = lineChunks.split(' ');
        if (lineParts.length > 8 && lineParts[6] == 'new') {
          // constructor logging
          return "${lineParts[6]} ${lineParts[7]}";
        } else if (lineParts.length > 6) {
          return lineParts[6];
        } else {
          return _defaultTag;
        }
      } else {
        return _defaultTag;
      }
    } else {
      return _defaultTag; //default
    }
  }

  /// Gets tag with [stackIndex]
  /// how many steps in stacktrace should be taken to grab log call.
  static List<String> getStacktrace({
    int stackIndex = 6,
    LogRecord? record,
  }) {
    var stackTraceList = getAssociatedStackTrace(record).toString().split('\n');
    return stackTraceList.sublist(stackIndex);
  }
}
