import 'package:duoduo_cat/core/logging_service.dart';
import 'package:duoduo_cat/core/plugin_manager.dart';
import 'package:duoduo_cat/core/plugin_provider.dart';
import 'package:duoduo_cat/domain/plugin_info.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';

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
  Scaffold.of(ctx.context).showSnackBar(SnackBar(
    content: Text("install plugin success id:${action.payload["id"]}"),
  ));
  Navigator.of(ctx.context).pushNamed('home', arguments: null);
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
