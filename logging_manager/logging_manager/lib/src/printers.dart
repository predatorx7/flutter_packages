import 'dart:io';
import 'dart:developer' as devel;

import 'package:logging/logging.dart';

abstract class LoggerOutput {
  const LoggerOutput();

  void call(String message, LogRecord record);

  factory LoggerOutput.developerMessage() {
    return DeveloperLoggerOutput();
  }

  factory LoggerOutput.developerLogRecord() {
    return DeveloperLogRecordLoggerOutput();
  }

  factory LoggerOutput.corePrinter() {
    return CorePrinterLoggerOutput();
  }

  factory LoggerOutput.standardOutput() {
    return StandardOuputLoggerOutput();
  }
}

class DeveloperLoggerOutput implements LoggerOutput {
  const DeveloperLoggerOutput();

  @override
  void call(String message, LogRecord record) {
    devel.log(message);
  }
}

class DeveloperLogRecordLoggerOutput implements LoggerOutput {
  const DeveloperLogRecordLoggerOutput();

  @override
  void call(String message, LogRecord record) {
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
}

class CorePrinterLoggerOutput implements LoggerOutput {
  const CorePrinterLoggerOutput();

  @override
  void call(String message, LogRecord record) {
    print(message);
  }
}

class StandardOuputLoggerOutput implements LoggerOutput {
  const StandardOuputLoggerOutput();

  @override
  void call(String message, LogRecord record) {
    if (record.level.value >= Level.SEVERE.value) {
      stderr.writeln(message);
    } else {
      stdout.writeln(message);
    }
  }
}
