/// Copyright 2013, the Dart project authors.
///
/// Redistribution and use in source and binary forms, with or without
/// modification, are permitted provided that the following conditions are
/// met:
///
///     * Redistributions of source code must retain the above copyright
///       notice, this list of conditions and the following disclaimer.
///     * Redistributions in binary form must reproduce the above
///       copyright notice, this list of conditions and the following
///       disclaimer in the documentation and/or other materials provided
///       with the distribution.
///     * Neither the name of Google LLC nor the names of its
///       contributors may be used to endorse or promote products derived
///       from this software without specific prior written permission.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
/// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
/// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
/// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
/// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
/// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
/// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
/// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
/// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
/// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
///

import 'package:logging/logging.dart';

/// This is a wrapper around [Logger] which allows you to create child loggers by calling `()` on the instance.
/// This is useful for creating loggers with different namespaces.
///
/// Example:
/// ```dart
/// Logger logger = Logger('my.namespace');
///
/// final logging = Logging(logger);
/// logging.info('Hello'); // will print to console with namespace 'my.namespace'.
///
/// final sampleLogger = logging('Sample');
/// sampleLogger.info('Hello'); // will print to console with namespace 'my.namespace.Sample'.
/// ```
///
class Logging {
  final String name;

  /// All logging methods on this class are delegated to this [Logger].
  final Logger logger;

  /// Create a new [Logging] instance with a name.
  Logging(this.name) : logger = Logger(name);

  /// Create a new [Logging] instance with a [Logger].
  Logging.fromLogger(this.logger) : name = logger.fullName;

  /// Create a new child [Logging] instance with a [name].
  ///
  /// The full name of this new Logging will be this logging's full name + the [name].
  Logging call(String name) {
    assert(name.isNotEmpty, 'Name should not be empty');

    return Logging('${logger.fullName}.$name');
  }

  /// Log message at level [Level.FINEST].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void finest(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.finest(message, error, stackTrace);

  /// Log message at level [Level.FINER].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void finer(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.finer(message, error, stackTrace);

  /// Log message at level [Level.FINE].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void fine(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.fine(message, error, stackTrace);

  /// Log message at level [Level.CONFIG].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void config(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.config(message, error, stackTrace);

  /// Log message at level [Level.INFO].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void info(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.info(message, error, stackTrace);

  /// Log message at level [Level.WARNING].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void warning(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.warning(message, error, stackTrace);

  /// Log message at level [Level.SEVERE].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void severe(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.severe(message, error, stackTrace);

  /// Log message at level [Level.SHOUT].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void shout(Object? message, [Object? error, StackTrace? stackTrace]) =>
      logger.shout(message, error, stackTrace);

  /// Adds a log record for a [message] at a particular [logLevel] if
  /// `isLoggable(logLevel)` is true.
  ///
  /// Use this method to create log entries for user-defined levels. To record a
  /// message at a predefined level (e.g. [Level.INFO], [Level.WARNING], etc)
  /// you can use their specialized methods instead (e.g. [info], [warning],
  /// etc).
  ///
  /// If [message] is a [Function], it will be lazy evaluated. Additionally, if
  /// [message] or its evaluated value is not a [String], then 'toString()' will
  /// be called on the object and the result will be logged. The log record will
  /// contain a field holding the original object.
  ///
  /// The log record will also contain a field for the zone in which this call
  /// was made. This can be advantageous if a log listener wants to handler
  /// records of different zones differently (e.g. group log records by HTTP
  /// request if each HTTP request handler runs in it's own zone).
  void log(
    Level logLevel,
    Object? message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    return logger.log(logLevel, message, error, stackTrace);
  }

  /// Returns a stream of messages added to this [logger].
  ///
  /// You can listen for messages using the standard stream APIs, for instance:
  ///
  /// ```dart
  /// logger.onRecord.listen((record) { ... });
  /// ```
  ///
  Stream<LogRecord> get onRecord => logger.onRecord;
}
