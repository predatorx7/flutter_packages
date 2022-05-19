import 'package:logging_manager/logging_manager.dart';

void main() {
  final logginManager = LoggingManager(
    logger: Logger('CustomLoggingManager'),
    tree: PrintingColoredLogsTree(),
  );

  // or just Logger('CustomLoggingManager');
  final logger = logginManager.logger;

  testPrinting(logger, 'PrintingColoredLogsTree');
  logginManager.removeTree();
  testPrinting(logger, 'NotPrintingLogs');
  logginManager.plantTree(PrintingLogsTree());
  testPrinting(logger, 'PrintingLogsTree');

  final childLogger = logginManager.getLogger('child_logger');

  testPrinting(childLogger, 'PrintingColoredLogsTree');
  logginManager.removeTree();
  testPrinting(childLogger, 'NotPrintingLogs');
  logginManager.plantTree(PrintingLogsTree());
  testPrinting(childLogger, 'PrintingLogsTree');
}

void testPrinting(Logger logger, String treeType) {
  logger.fine(
      '------------------------------------------------------------------');
  logger.config('This is a config from $treeType');
  logger.info('This is a info from $treeType');
  logger.warning('This is a warning from $treeType');
  logger.severe('This is a warning from $treeType');
  logger.shout('This is a shout from $treeType');

  try {
    throw Exception('Fake error');
  } catch (e, s) {
    logger.severe(
      'Severe error caught with stack trace. This is a from $treeType',
      e,
      s,
    );
  }
}
