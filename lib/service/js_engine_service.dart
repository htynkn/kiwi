import 'package:flutter/services.dart';

class JsEngineService {
  static const platform = const MethodChannel('com.huangyunkun.kiwi/jsEngine');

  Future<String> executeJs(String script, String method) async {
    final String result = await platform
        .invokeMethod('executeJs', {"script": script, "method": method});
    return Future.value(result);
  }

  Future<String> executeJsWithContext(
      String script, String method, Map<String, dynamic> context) async {
    final String result = await platform.invokeMethod('executeJsWithContext',
        {"script": script, "method": method, "context": context});
    return Future.value(result);
  }
}
