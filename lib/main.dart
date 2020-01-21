import 'package:kiwi/service/dio_http_service.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:kiwi/service/sited_plugin_provider.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'core/http_service.dart';
import 'core/logging_service.dart';
import 'core/plugin_provider.dart';

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
}
