import 'package:logging_manager/logging_manager.dart';

void main() {
  final loggingManager = LoggingManager(logger: Logger('MyApp'));

  // or just Logger(''); for getting the root logger.
  final logger = Logger('MyApp');

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

  /// This won't print anything because the logging manager is managing logs from
  /// MyApp and its children. The logger below is root logger and its not a children
  /// of the logger the above logging manager manages.
  final rootLogger = Logger('');

  testPrinting(rootLogger, 'PrintingColoredLogsTree');
  loggingManager.removeTree();
  testPrinting(rootLogger, 'NotPrintingLogs');
  loggingManager.plantTree(PrintingLogsTree());
  testPrinting(rootLogger, 'PrintingLogsTree');
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
