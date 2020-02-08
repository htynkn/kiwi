import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/service/dio_http_service.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:kiwi/service/sited_plugin_provider.dart';

import 'mock_analysis_service.dart';

void main() {
  group("sited_plugin_provider_test", () {
    var provider;

    setUp(() {
      var loggingService = SimpleLoggingService();

      provider = new SitedPluginProvider(
          DioHttpService(MockAnalysisService(), loggingService),
          loggingService);
    });

    test("get_comic_list", () async {
      var list = provider.list();

      list.then((value) {
        expect(value.length, greaterThan(0));
      });
      expect(list, completes);
    });

    test("search_comic_plugin", () {
      var list = provider.search("漫画");

      list.then((value) {
        expect(value.length, greaterThan(0));
        expect(value[0].remoteUrl, isNotEmpty);
      });
      expect(list, completes);
    });

    test('download_and_decrypt_plugin', () {
      String remoteUrl =
          "sited://data?aHR0cDovL3NpdGVkLm5vZWFyLm9yZy9pbWcvYThjNmM1NTFiNDU2NDA3MmJhZDlhZGZhYzcxNmM1MTIuc2l0ZWQueG1s";

      var result = provider.download(remoteUrl);

      result.then((value) {
        expect(value, isNotEmpty);
        expect(value, contains("xml"));
      });
      expect(result, completes);
    });
  });
}
