import 'package:duoduo_cat/service/mock_plugin_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("mock loader test", () {
    test('should get list', () async {
      var pluginLoader = MockPluginLoader();

      var list = await pluginLoader.load();

      expect(list, isNotNull);
      expect(list.length, equals(1));
    });
  });
}
