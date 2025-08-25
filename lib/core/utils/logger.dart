import 'package:coin_market_app/core/config/env_config.dart';

class AppLogger {
  static void log(
    String message, {
    String? tag,
    LogLevel level = LogLevel.info,
  }) {
    if (!EnvConfig.enableLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final logTag = tag ?? 'AppLogger';
    final logMessage = '[$timestamp] [$logTag] [$level] $message';

    switch (level) {
      case LogLevel.debug:
        print('\u001b[34m$logMessage\u001b[0m'); // Blue
        break;
      case LogLevel.info:
        print('\u001b[32m$logMessage\u001b[0m'); // Green
        break;
      case LogLevel.warning:
        print('\u001b[33m$logMessage\u001b[0m'); // Yellow
        break;
      case LogLevel.error:
        print('\u001b[31m$logMessage\u001b[0m'); // Red
        break;
    }
  }

  static void debug(String message, {String? tag}) {
    log(message, tag: tag, level: LogLevel.debug);
  }

  static void info(String message, {String? tag}) {
    log(message, tag: tag, level: LogLevel.info);
  }

  static void warning(String message, {String? tag}) {
    log(message, tag: tag, level: LogLevel.warning);
  }

  static void error(String message, {String? tag, dynamic error}) {
    final errorMessage = error != null ? '$message\nError: $error' : message;
    log(errorMessage, tag: tag, level: LogLevel.error);
  }
}

enum LogLevel { debug, info, warning, error }
