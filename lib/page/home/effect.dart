import 'package:duoduo_cat/core/plugin_manager.dart';
import 'package:duoduo_cat/service/default_plugin_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/widgets.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'action.dart';
import 'state.dart';

Effect<HomePageState> buildEffect() {
  return combineEffects(<Object, Effect<HomePageState>>{
    Lifecycle.initState: _startLoad,
    HomeAction.jumpToInstall: _jumpToInstall
  });
}

Future<void> _startLoad(Action action, Context<HomePageState> ctx) async {
  var loader = GetIt.I;

  var pluginManager = safetyLoad();

  if (pluginManager == null) {
    var directory = await getApplicationDocumentsDirectory();

    pluginManager = DefaultPluginManager(directory.path);
    loader.registerSingleton<PluginManager>(pluginManager);

    var list = await pluginManager.load();
    ctx.dispatch(HomeActionCreator.loadPlugin(list));
  } else {
    pluginManager.load().then((list) {
      ctx.dispatch(HomeActionCreator.loadPlugin(list));
    });
  }
}

void _jumpToInstall(Action action, Context<HomePageState> ctx) {
  Navigator.of(ctx.context).pushNamed('install', arguments: null);
}

safetyLoad() {
  var loader = GetIt.I;
  try {
    var pluginManager = loader.get<PluginManager>();
    return pluginManager;
  } catch (e) {
    return null;
  }
}
