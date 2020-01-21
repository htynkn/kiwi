import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/page/home/action.dart';

import 'action.dart';
import 'state.dart';

Effect<InstallState> buildEffect() {
  return combineEffects(<Object, Effect<InstallState>>{
    Lifecycle.initState: _fetch,
    InstallAction.install: _install,
    InstallAction.finishInstall: _finishInstall
  });
}

_finishInstall(Action action, Context<InstallState> ctx) async {
  Navigator.of(ctx.context).pushReplacementNamed('home', arguments: null);
  ctx.dispatch(HomeActionCreator.reload());
}

Future<void> _fetch(Action action, Context<InstallState> ctx) async {
  var loader = GetIt.I;

  var pluginProvider = loader.get<PluginProvider>();

  var list = await pluginProvider.list(1, 200);

  ctx.dispatch(InstallActionCreator.loadFinish(list));
}

Future<void> _install(Action action, Context<InstallState> ctx) async {
  var loader = GetIt.I;

  var pluginProvider = loader.get<PluginProvider>();
  var pluginManager = loader.get<PluginManager>();
  var loggingService = loader.get<LoggingService>();

  loggingService.debug("start install ${action.payload}");

  String name = action.payload["name"];
  String remoteUrl = action.payload["remoteUrl"];

  String xmlContent = await pluginProvider.download(remoteUrl);

  var pluginId = await pluginManager.install(PluginInfo(name, ""), xmlContent);

  ctx.dispatch(
      InstallActionCreator.finishInstall({"name": name, "id": pluginId}));
}
