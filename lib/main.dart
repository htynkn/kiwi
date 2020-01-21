import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/service/dio_http_service.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:kiwi/service/sited_plugin_provider.dart';

import 'app.dart';
import 'core/http_service.dart';
import 'core/logging_service.dart';
import 'core/plugin_provider.dart';
import 'service/default_plugin_executor.dart';
import 'service/js_engine_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLoader();
  runApp(createApp());
}

void initServiceLoader() {
  var loader = GetIt.I;

  loader.registerLazySingleton<LoggingService>(() => SimpleLoggingService());
  loader.registerLazySingleton<HttpService>(() => DioHttpService());
  loader.registerLazySingleton<PluginProvider>(() => SitedPluginProvider());

  loader.registerLazySingleton<JsEngineService>(() => JsEngineService());
  loader.registerLazySingleton<DefaultPluginExecutor>(
      () => DefaultPluginExecutor());
}
