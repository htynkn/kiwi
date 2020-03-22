import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/service/default_plugin_executor.dart';

import '../../error.dart';
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
  try {
    var defaultPluginExecutor = GetIt.I.get<DefaultPluginExecutor>();

    var raw = await defaultPluginExecutor.getRawInfoBy(ctx.state.pluginId);

    var tagName = raw.main.tags?.title;
    var homeName = raw.main.home?.title;

    var list = await defaultPluginExecutor.getComicBooks(raw);

    var tags = await defaultPluginExecutor.getComicTags(raw);

    ctx.dispatch(ComicBookActionCreator.finishLoad(
        raw.meta.title, homeName, tagName, list, tags));
  } catch (e) {
    commonErrorHandler(e, ctx);
  }
}
