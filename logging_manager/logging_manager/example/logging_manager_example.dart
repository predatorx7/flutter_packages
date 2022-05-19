import 'package:logging_manager/logging_manager.dart';
import 'package:logging_manager/src/default_logging_manager.dart';

void main() {
  // or just Logger('CustomLoggingManager');
  final logger = loggingManager.logger;

  testPrinting(logger, 'PrintingColoredLogsTree');
  loggingManager.removeTree();
  testPrinting(logger, 'NotPrintingLogs');
  loggingManager.plantTree(PrintingLogsTree());
  testPrinting(logger, 'PrintingLogsTree');

  final childLogger = loggingManager.getLogger('child_logger');

  testPrinting(childLogger, 'PrintingColoredLogsTree');
  loggingManager.removeTree();
  testPrinting(childLogger, 'NotPrintingLogs');
  loggingManager.plantTree(PrintingLogsTree());
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
