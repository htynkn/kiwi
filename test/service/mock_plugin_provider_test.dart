import 'package:duoduo_cat/service/mock_plugin_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("mock provider test", () {
    test('should get list', () async {
      var pluginProvider = MockPluginProvider();

      var list = pluginProvider.list(1, 20);

      expect(list, isNotNull);
    });
  });
}
