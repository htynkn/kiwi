import 'package:duoduo_cat/service/dio_http_service.dart';
import 'package:duoduo_cat/service/simple_logging_service.dart';
import 'package:duoduo_cat/service/sited_plugin_provider.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';

import 'core/http_service.dart';
import 'core/logging_service.dart';
import 'core/plugin_provider.dart';
import 'page/home/page.dart';

Widget createApp() {
  var loader = GetIt.I;

  loader.registerLazySingleton<LoggingService>(() => SimpleLoggingService());
  loader.registerLazySingleton<HttpService>(() => DioHttpService());
  loader.registerLazySingleton<PluginProvider>(() => SitedPluginProvider());

  final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      'home': HomePage(),
    },
    visitor: (String path, Page<Object, dynamic> page) {
      page.enhancer.append(
        viewMiddleware: <ViewMiddleware<dynamic>>[
          safetyView<dynamic>(),
        ],
        adapterMiddleware: <AdapterMiddleware<dynamic>>[
          safetyAdapter<dynamic>()
        ],
        effectMiddleware: <EffectMiddleware<dynamic>>[
          _pageAnalyticsMiddleware<dynamic>(),
        ],
        middleware: <Middleware<dynamic>>[
          logMiddleware<dynamic>(tag: page.runtimeType.toString()),
        ],
      );
    },
  );

  return MaterialApp(
    title: 'App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: routes.buildPage('home', null),
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute<Object>(builder: (BuildContext context) {
        return routes.buildPage(settings.name, settings.arguments);
      });
    },
  );
}

EffectMiddleware<T> _pageAnalyticsMiddleware<T>({String tag = 'redux'}) {
  return (AbstractLogic<dynamic> logic, Store<T> store) {
    return (Effect<dynamic> effect) {
      return (Action action, Context<dynamic> ctx) {
        if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
          print('${logic.runtimeType} ${action.type.toString()} ');
        }
        return effect?.call(action, ctx);
      };
    };
  };
}
