import 'package:get_it/get_it.dart';
import 'package:kiwi/core/analysis_service.dart';
import 'package:kiwi/core/http_service.dart';
import 'package:kiwi/core/js_engine_service.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/domain/enum/js_engine_type.dart';
import 'package:kiwi/domain/enum/plugin_provider_type.dart';
import 'package:kiwi/service/adapter/js_engine_adapter.dart';
import 'package:kiwi/service/file_plugin_provider.dart';
import 'package:kiwi/service/firebase_analysis_service.dart';
import 'package:kiwi/service/ka94_plugin_provider.dart';
import 'package:kiwi/service/rhino_js_engine_service.dart';
import 'package:kiwi/service/simple_logging_service.dart';
import 'package:kiwi/service/sited_plugin_provider.dart';
import 'package:kiwi/service/v8_js_engine_service.dart';

import 'core/js_engine_service.dart';
import 'core/plugin_manager.dart';
import 'service/default_plugin_executor.dart';
import 'service/default_plugin_manager.dart';
import 'service/dio_http_service.dart';

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
      loader.registerLazySingleton<JsEngineService>((() => JsEngineAdapter()));

      loader.registerLazySingleton<JsEngineService>((() => V8JsEngineService()),
          instanceName: JsEngineType.V8.toString());

      loader.registerLazySingleton<JsEngineService>(
          (() => RhinoJsEngineService()),
          instanceName: JsEngineType.Rhino.toString());
    }

    loader.registerLazySingleton<HttpService>((() => DioHttpService(
        loader.get<AnalysisService>(), loader.get<LoggingService>())));

    loader.registerLazySingleton<PluginProvider>(
        (() => SitedPluginProvider(
            loader.get<HttpService>(), loader.get<LoggingService>())),
        instanceName: PluginProviderType.Sited.toString());

    loader.registerLazySingleton<PluginProvider>(
        (() => Ka94PluginProvider(
            loader.get<HttpService>(), loader.get<LoggingService>())),
        instanceName: PluginProviderType.Ka94.toString());

    loader.registerLazySingleton<PluginProvider>(
        (() => FilePluginProvider(loader.get<LoggingService>())),
        instanceName: PluginProviderType.File.toString());

    loader.registerLazySingleton<PluginManager>(
        () => DefaultPluginManager(loader.get()));

    loader.registerLazySingleton<DefaultPluginExecutor>((() =>
        DefaultPluginExecutor(loader.get(), loader.get(), loader.get())));

    return loader;
  }
}
