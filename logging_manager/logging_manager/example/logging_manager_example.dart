import 'package:logging/logging.dart';
import 'package:logging_manager/logging_manager.dart';

void main() {
  final logginManager = LoggingManager(
    loggerName: 'CustomLoggingManager',
    tree: PrintingColoredLogsTree(),
  );

  final logger = logginManager.root;

  testPrinting(logger, 'PrintingColoredLogsTree');
  logginManager.removeTree();
  testPrinting(logger, 'NotPrintingLogs');
  logginManager.plantTree(PrintingLogsTree());
  testPrinting(logger, 'PrintingLogsTree');
}

void testPrinting(Logger logger, String treeType) {
  logger.fine(
      '------------------------------------------------------------------');
  logger.config('This is a config from $treeType');
  logger.info('This is a info from $treeType');
  logger.warning('This is a warning from $treeType');
  logger.severe('This is a warning from $treeType');
  logger.shout('This is a shout from $treeType');
}
