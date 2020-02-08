abstract class LoggingService {
  void debug(String m);

  void error(dynamic message, [dynamic error, StackTrace stackTrace]);
}
