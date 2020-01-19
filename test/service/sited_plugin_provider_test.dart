import 'package:duoduo_cat/core/http_service.dart';
import 'package:duoduo_cat/core/logging_service.dart';
import 'package:duoduo_cat/service/dio_http_service.dart';
import 'package:duoduo_cat/service/simple_logging_service.dart';
import 'package:duoduo_cat/service/sited_plugin_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group("sited_plugin_provider_test", () {
    setUpAll(() {
      var loader = GetIt.I;

      loader.registerSingleton<LoggingService>(new SimpleLoggingService());
      loader.registerSingleton<HttpService>(new DioHttpService());
    });

    test("get_comic_list", () async {
      var provider = SitedPluginProvider();

      var list = provider.list();

      list.then((value) {
        expect(value.length, greaterThan(0));
      });
      expect(list, completes);
    });

    test("search_comic_plugin", () {
      var provider = SitedPluginProvider();

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
      var provider = SitedPluginProvider();

      var result = provider.download(remoteUrl);

      result.then((value) {
        expect(value, isNotEmpty);
        expect(value, contains("xml"));
      });
      expect(result, completes);
    });
  });
}
