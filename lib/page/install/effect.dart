import 'package:basic_utils/basic_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/core/logging_service.dart';
import 'package:kiwi/core/plugin_manager.dart';
import 'package:kiwi/core/plugin_provider.dart';
import 'package:kiwi/domain/plugin_info.dart';
import 'package:kiwi/page/home/action.dart';
import 'package:kiwi/service/default_plugin_executor.dart';

import 'action.dart';
import 'state.dart';

Effect<InstallState> buildEffect() {
  return combineEffects(<Object, Effect<InstallState>>{
    Lifecycle.initState: _fetch,
    InstallAction.install: _install,
    InstallAction.finishInstall: _finishInstall,
    InstallAction.search: _search,
    InstallAction.switchProvider: _switchProvider
  });
}

_search(Action action, Context<InstallState> ctx) async {
  var loader = GetIt.I;

  var pluginProvider =
      loader.get<PluginProvider>(ctx.state.providerType.toString());

  String keyWord = action.payload;

  var list = await pluginProvider.search(keyWord);

  ctx.dispatch(InstallActionCreator.loadFinish(keyWord, list));
}

_finishInstall(Action action, Context<InstallState> ctx) async {
  Navigator.of(ctx.context).pushReplacementNamed('home', arguments: null);
  ctx.dispatch(HomeActionCreator.reload());
}

_switchProvider(Action action, Context<InstallState> ctx) async {
  ctx.dispatch(InstallActionCreator.startSwitchProvider(action.payload));

  var loader = GetIt.I;

  var pluginProvider = loader.get<PluginProvider>(action.payload.toString());

  var list = await pluginProvider.list(1, 200);

  ctx.dispatch(InstallActionCreator.loadFinish("", list, type: action.payload));
}

Future<void> _fetch(Action action, Context<InstallState> ctx) async {
  var loader = GetIt.I;

  var pluginProvider =
      loader.get<PluginProvider>(ctx.state.providerType.toString());

  var list = await pluginProvider.list(1, 200);

  ctx.dispatch(InstallActionCreator.loadFinish("", list));
}

Future<void> _install(Action action, Context<InstallState> ctx) async {
  var loader = GetIt.I;

  var pluginProvider =
      loader.get<PluginProvider>(ctx.state.providerType.toString());
  var pluginManager = loader.get<PluginManager>();
  var loggingService = loader.get<LoggingService>();

  loggingService.debug("start install ${action.payload}");

  String name = action.payload["name"];
  String remoteUrl = action.payload["remoteUrl"];

  String xmlContent = await pluginProvider.download(remoteUrl);

  if (StringUtils.isNullOrEmpty(name)) {
    DefaultPluginExecutor executor = loader.get<DefaultPluginExecutor>();
    name = (await executor.getRawInfoContent(xmlContent)).meta?.title;
  }

  var pluginId = await pluginManager.install(PluginInfo(name, ""), xmlContent);

  ctx.dispatch(
      InstallActionCreator.finishInstall({"name": name, "id": pluginId}));
}
