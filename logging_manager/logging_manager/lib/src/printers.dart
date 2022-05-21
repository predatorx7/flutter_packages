import 'dart:io';
import 'dart:developer' as devel;

import 'package:logging/logging.dart';

final printers = LogOutput();

class LogOutput {
  const LogOutput();

  void develMessage(String message, LogRecord record) {
    devel.log(message);
  }

  void develLogRecord(String message, LogRecord record) {
    devel.log(
      record.message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }

  void core(String message, LogRecord record) {
    print(message);
  }

  void standard(String message, LogRecord record) {
    if (record.level.value >= Level.SEVERE.value) {
      stderr.writeln(message);
    } else {
      stdout.writeln(message);
    }
  }
}
