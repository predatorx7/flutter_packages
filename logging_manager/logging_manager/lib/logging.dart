/// This library providers [Logging], a wrapper around [Logger] which allows you to create child loggers by calling `()` on the instance.
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
library logging;

export 'src/logging.dart';
