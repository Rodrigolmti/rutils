import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:rutils_logger/src/rutils_logger_options.dart';

/// To use the logger and send data to logzIo you must
/// call the setup method before using it
/// with the credentials that you can get on the log.io website
///
/// This class uses the native console to log the data,
/// any log that you may shout in your
/// application will be logged to the console with the given configurations.
/// It also applies to the logzIo if you have setup it will receive the data
class RUtilsLogger {
  RUtilsLogger._();

  static RUtilsLogger I = RUtilsLogger._();

  final Logger _logger = Logger.root;

  void setup(RUtilsLoggerOptions options) {
    Logger.root.level = options.level;
    PrintAppender(formatter: const ColorFormatter()).attachToLogger(_logger);

    if (options.logzioToken != null && options.logzioHost != null) {
      LogzIoApiAppender(
        apiToken: options.logzioToken!,
        url: options.logzioHost!,
        labels: options.labels ?? {},
        formatter: const ColorFormatter(),
      ).attachToLogger(_logger);
    }
  }

  /// Log a message at level debug.
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.shout(message, error, stackTrace);

  /// Log a message at level error.
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.severe(message, error, stackTrace);

  /// Log a message at level info.
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.info(message, error, stackTrace);

  /// Log a message at level verbose.
  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.finest(message, error, stackTrace);

  /// Log a message at level warning.
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.warning(message, error, stackTrace);
}
