import 'package:flutter_test/flutter_test.dart';

import 'node_js_engine_service.dart';

void main() {
  group("test_node_js", () {
    test("test_script", () async {
      var nodeJsEngineService = NodeJsEngineService();

      var result = await nodeJsEngineService.executeJs(
          "var c = function(a,b) { return a+b;}", "c(1,2)");

      expect(result, equals("3"));
    });

    test("test_script_with_context", () async {
      var nodeJsEngineService = NodeJsEngineService();

      Map<String, dynamic> map = Map();

      map.putIfAbsent("x", () => 1);
      map.putIfAbsent("y", () => 2);

      var result = await nodeJsEngineService.executeJsWithContext(
          "var c = function(a,b) { return a+b;}", "c(x,y)", map);

      expect(result, equals("3"));
    });
  });
}
