part of 'utility.dart';

var log = logging.Logger('');

final logger = Logger(printer: PrettyPrinter(methodCount: 3));

void initLogger() {
  // only enable logging for debug mode
  if (kDebugMode) {
    logging.Logger.root.level = logging.Level.FINER;
  } else {
    logging.Logger.root.level = logging.Level.OFF;
  }

  logging.Logger.root.onRecord.listen((record) {
    if (!kDebugMode) return;

    var start = '\x1b[34m';
    var emoji = '🗣';
    const end = '\x1b[0m';

    switch (record.level.name) {
      case 'FINE':
        start = '\x1b[94m';
        break;
      case 'CONFIG':
        start = '\x1b[96m';
        emoji = '🛠';
        break;
      case 'INFO':
        start = '\x1b[92m';
        emoji = '💡';
        break;
      case 'WARNING':
        start = '\x1b[33;1m';
        emoji = '❗️';
        break;
      case 'SEVERE':
        start = '\x1b[91m';
        emoji = '⛔️';
        break;
      case 'SHOUT':
        start = '\x1b[41m\x1b[93;5m';
        emoji = '🆘';
        break;
    }

    final ts = DateFormat('HH:mm:ss.SSS').format(record.time);
    final errorSuffix = record.error != null ? ' — ERROR: ${record.error}' : '';
    final message = '$start$ts $emoji ${record.message}$errorSuffix$end';
    dev.log(
      message,
      name: record.loggerName,
      level: record.level.value,
      time: record.time,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}
