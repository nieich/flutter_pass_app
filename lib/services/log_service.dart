import 'dart:collection';

import 'package:logging/logging.dart';

/// An abstract interface for a logging service.
///
/// This allows for different implementations (e.g., for production, testing)
/// and improves testability by allowing mocks to be injected.
abstract class LogService {
  /// Returns an unmodifiable list of the captured logs.
  List<LogRecord> get logs;

  /// Adds a new log record to the store.
  void add(LogRecord record);

  /// Formats all logs into a single shareable string.
  String getLogsAsString();

  /// Clears all captured logs.
  void clear();
}

/// A concrete implementation of [LogService] that stores logs in memory.
class LogServiceImpl implements LogService {
  LogServiceImpl() {
    // Listen to all logs in the app.
    // This allows any logger from the `logging` package to be captured.
    Logger.root.onRecord.listen(add);
  }

  static const int _maxLogs = 100;
  final Queue<LogRecord> _logs = Queue<LogRecord>();

  @override
  List<LogRecord> get logs => List.unmodifiable(_logs);

  @override
  void add(LogRecord record) {
    if (_logs.length >= _maxLogs) {
      _logs.removeFirst();
    }
    _logs.add(record);
  }

  @override
  String getLogsAsString() {
    return _logs.map((record) => '${record.level.name}: ${record.time}: ${record.message}').join('\n');
  }

  @override
  void clear() {
    _logs.clear();
  }
}
