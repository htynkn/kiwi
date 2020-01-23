import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/service/default_plugin_executor.dart';

import 'action.dart';
import 'state.dart';

Effect<ComicBookState> buildEffect() {
  return combineEffects(<Object, Effect<ComicBookState>>{
    Lifecycle.initState: _init,
    ComicBookAction.startLoad: _startLoad,
    ComicBookAction.jumpToSection: _jumpToSection,
  });
}

_init(Action action, Context<ComicBookState> ctx) {
  Future.delayed(Duration(milliseconds: 100), () {
    ctx.dispatch(ComicBookActionCreator.startLoad());
  });
}

_jumpToSection(Action action, Context<ComicBookState> ctx) {
  Navigator.of(ctx.context)
      .pushNamed('comic_section', arguments: action.payload);
}

_startLoad(Action action, Context<ComicBookState> ctx) async {
  var defaultPluginExecutor = GetIt.I.get<DefaultPluginExecutor>();

  defaultPluginExecutor.getRawInfoBy(ctx.state.pluginId).then((raw) {
    defaultPluginExecutor.getComicBooks(raw).then((list) {
      ctx.dispatch(ComicBookActionCreator.finishLoad(raw.meta.title, list));
    });
  });
}
