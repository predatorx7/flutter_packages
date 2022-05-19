import 'package:logging_manager/logging_manager.dart';
import 'package:logging_manager/src/stack_frame.dart';

/// The default logging manager that uses the a child from the root Logger.
final loggingManager = LoggingManager(
  logger: Logger('DefaultLogger'),
  tree: kReleaseMode ? null : PrintingColoredLogsTree(),
);
