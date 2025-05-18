import 'package:logging/logging.dart';

class RUtilsLoggerOptions {
  /// Log level to use.
  final Level level;
  final String? logzioToken;
  final String? logzioHost;

  /// Labels that are going to be added to every log message.
  final Map<String, String>? labels;

  const RUtilsLoggerOptions({
    this.labels = const {},
    this.level = Level.ALL,
    this.logzioToken,
    this.logzioHost,
  });

  RUtilsLoggerOptions copyWith({
    Level? level,
    String? logzioToken,
    String? logzioHost,
    Map<String, String>? labels,
  }) =>
      RUtilsLoggerOptions(
        level: level ?? this.level,
        logzioToken: logzioToken ?? this.logzioToken,
        logzioHost: logzioHost ?? this.logzioHost,
        labels: labels ?? this.labels,
      );
}
