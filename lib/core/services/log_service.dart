import 'package:logger/logger.dart';

class LogService {
  // custom style simple logger
  static final logger = Logger(
    output: ConsoleOutput(),
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: (time) => "${time.hour}:${time.minute}:${time.second}",
    ),
  );

  static void t(String message) => logger.t(message);
  static void d(String message) => logger.d(message);
  static void i(String message) => logger.i(message);
  static void w(String message) => logger.w(message);
  static void e(String message, error, StackTrace? stackTrace) =>
      logger.e(message, error: error, stackTrace: stackTrace);
}
