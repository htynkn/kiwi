import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/widgets.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/plugin_manager.dart';

import 'action.dart';
import 'state.dart';

Effect<HomePageState> buildEffect() {
  return combineEffects(<Object, Effect<HomePageState>>{
    Lifecycle.initState: _init,
    HomeAction.reload: _startLoad,
    HomeAction.startLoad: _startLoad,
    HomeAction.clickBook: _clickBook,
    HomeAction.jumpToInstall: _jumpToInstall,
    HomeAction.deletePlugin: _deletePlugin
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

  var pluginManager = loader.get<PluginManager>();

  var list = await pluginManager.load();
  ctx.dispatch(HomeActionCreator.finishLoadPlugin(list));
}

void _jumpToInstall(Action action, Context<HomePageState> ctx) {
  Navigator.of(ctx.context).pushNamed('install', arguments: null);
}

Future<void> _deletePlugin(Action action, Context<HomePageState> ctx) async {
  var pluginId = action.payload;

  var loader = GetIt.I;

  var pluginManager = loader.get<PluginManager>();

  await pluginManager.deleteById(pluginId);

  await _startLoad(action, ctx);
}
