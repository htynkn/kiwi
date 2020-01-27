import 'package:get_it/get_it.dart';
import 'package:kiwi/core/analysis_service.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/js_engine_service.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/service/firebase_analysis_service.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:kiwi/service/sited_plugin_provider.dart';

import 'core/js_engine_service.dart';
import 'core/plugin_manager.dart';
import 'service/default_plugin_executor.dart';
import 'service/default_plugin_manager.dart';
import 'service/dio_http_service.dart';
import 'service/rhino_js_engine_service.dart';

class IocConfiguration {
  configDependencies(
      {AnalysisService analysisService, JsEngineService jsEngineService}) {
    var loader = GetIt.I;

    loader
        .registerLazySingleton<LoggingService>((() => SimpleLoggingService()));

    if (analysisService != null) {
      loader.registerLazySingleton<AnalysisService>((() => analysisService));
    } else {
      loader.registerLazySingleton<AnalysisService>(
          (() => FirebaseAnalysisService()));
    }

    if (jsEngineService != null) {
      loader.registerLazySingleton<JsEngineService>((() => jsEngineService));
    } else {
      loader.registerLazySingleton<JsEngineService>(
          (() => RhinoJsEngineService()));
    }

    loader.registerLazySingleton<HttpService>((() => DioHttpService(
        loader.get<AnalysisService>(), loader.get<LoggingService>())));

    loader.registerLazySingleton<PluginProvider>((() => SitedPluginProvider(
        loader.get<HttpService>(), loader.get<LoggingService>())));

    loader.registerLazySingleton<PluginManager>(
        () => DefaultPluginManager(loader.get()));

    loader.registerLazySingleton<DefaultPluginExecutor>((() =>
        DefaultPluginExecutor(loader.get(), loader.get(), loader.get())));

    return loader;
  }
}
