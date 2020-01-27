import 'package:kiwi/core/js_engine_service.dart';

class TestJsEngineService extends JsEngineService {
  @override
  Future<String> executeJs(String script, String method) {
    return null;
  }

  @override
  Future<String> executeJsWithContext(
      String script, String method, Map<String, dynamic> context) {
    return null;
  }
}
