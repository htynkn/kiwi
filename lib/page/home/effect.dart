import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/widgets.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/service/default_plugin_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'action.dart';
import 'state.dart';

Effect<HomePageState> buildEffect() {
  return combineEffects(<Object, Effect<HomePageState>>{
    Lifecycle.initState: _init,
    HomeAction.reload: _startLoad,
    HomeAction.startLoad: _startLoad,
    HomeAction.clickBook: _clickBook,
    HomeAction.jumpToInstall: _jumpToInstall
  });
}

_clickBook(Action action, Context<HomePageState> ctx) {
  Navigator.of(ctx.context)
      .pushNamed('comic_book', arguments: {"pluginId": action.payload});
}

_init(Action action, Context<HomePageState> ctx) {
  ctx.dispatch(HomeActionCreator.startLoad());
}

Future<void> _startLoad(Action action, Context<HomePageState> ctx) async {
  var loader = GetIt.I;

  var pluginManager = safetyLoad();

  if (pluginManager == null) {
    var directory = await getApplicationDocumentsDirectory();

    pluginManager = DefaultPluginManager(directory.path);
    loader.registerSingleton<PluginManager>(pluginManager);

    var list = await pluginManager.load();
    ctx.dispatch(HomeActionCreator.finishLoadPlugin(list));
  } else {
    var list = await pluginManager.load();
    ctx.dispatch(HomeActionCreator.finishLoadPlugin(list));
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
