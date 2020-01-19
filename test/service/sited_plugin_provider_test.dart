import 'package:duoduo_cat/core/http_service.dart';
import 'package:duoduo_cat/core/logging_service.dart';
import 'package:duoduo_cat/service/dio_http_service.dart';
import 'package:duoduo_cat/service/simple_logging_service.dart';
import 'package:duoduo_cat/service/sited_plugin_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group("sited_plugin_provider_test", () {
    setUp(() {
      var loader = GetIt.I;

      loader.registerSingleton<LoggingService>(new SimpleLoggingService());
      loader.registerSingleton<HttpService>(new DioHttpService());
    });

    test("get_comic_list", () async {
      var provider = SitedPluginProvider();

      var list = provider.list();

      list.then((value) {
        expect(value.length, greaterThan(-1));
      });
      expect(list, completes);
    });
  });
}
