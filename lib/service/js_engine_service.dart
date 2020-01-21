import 'package:flutter/services.dart';

class JsEngineService {
  static const platform = const MethodChannel('com.huangyunkun.kiwi/jsEngine');

  Future<String> executeJs(String script, String method) async {
    final String result = await platform
        .invokeMethod('executeJs', {"script": script, "method": method});
    return Future.value(result);
  }
}
