import 'package:logging/logging.dart';

/// A singleton service to capture and store application logs.
class LogService {
  // Singleton pattern setup
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  final List<LogRecord> _logs = [];

  /// Returns an unmodifiable list of the captured logs.
  List<LogRecord> get logs => List.unmodifiable(_logs);

  /// Adds a new log record to the store.
  void add(LogRecord record) {
    _logs.add(record);
  }

  /// Formats all logs into a single shareable string.
  String getLogsAsString() {
    return _logs.map((record) => '${record.level.name}: ${record.time}: ${record.message}').join('\n');
  }

  /// Clears all captured logs.
  void clear() {
    _logs.clear();
  }
}
