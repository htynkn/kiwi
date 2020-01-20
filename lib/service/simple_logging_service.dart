import 'package:kiwi/core/logging_service.dart';
import 'package:logger/logger.dart';

class SimpleLoggingService extends LoggingService {
  var logger = Logger();
  @override
  void debug(String m) {
    logger.d(m);
  }
}
