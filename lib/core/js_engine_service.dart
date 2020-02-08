abstract class JsEngineService {
  Future<String> executeJs(String script, String method);

  Future<String> executeJsWithContext(
      String script, String method, Map<String, dynamic> context);
}
