import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/service/dio_http_service.dart';
import 'package:kiwi/service/ka94_plugin_provider.dart';
import 'package:kiwi/service/simple_logging_service.dart';

import 'mock_analysis_service.dart';

void main() {
  PluginProvider provider;

  setUp(() {
    provider = Ka94PluginProvider(
        DioHttpService(MockAnalysisService(), SimpleLoggingService()),
        SimpleLoggingService());
  });

  group("ka94", () {
    test("test_get_list", () async {
      var list = await provider.list(1, 200);

      expect(list, isNotEmpty);

      var item = list[0];

      var result = await provider.download(item.remoteUrl);

      expect(result, isNotNull);
      expect(result.contains("xml"), isTrue);
    });

    test("test_search", () async {
      var list = await provider.search("177");

      expect(list, isNotEmpty);
    });
  });
}
