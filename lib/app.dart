import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:kiwi/page/comic_book/page.dart';
import 'package:kiwi/page/comic_detail/page.dart';
import 'package:kiwi/page/install/page.dart';
import 'package:kiwi/theme.dart';

import 'page/comic_section/page.dart';
import 'page/home/page.dart';
import 'page/comic_section/page.dart';

Widget createApp() {
  final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      'home': HomePage(),
      'install': InstallPage(),
      'comic_book': ComicBookPage(),
      'comic_section': ComicSectionPage(),
      'comic_detail': ComicDetailPage(),
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
    title: 'Kiwi',
    debugShowCheckedModeBanner: false,
    theme: myTheme,
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
