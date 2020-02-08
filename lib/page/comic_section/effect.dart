import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:kiwi/service/default_plugin_executor.dart';

import '../../error.dart';
import 'action.dart';
import 'state.dart';

Effect<ComicSectionState> buildEffect() {
  return combineEffects(<Object, Effect<ComicSectionState>>{
    Lifecycle.initState: _init,
    ComicSectionAction.startLoad: _startLoad,
    ComicSectionAction.jumpToDetail: _jumpToDetail
  });
}

_jumpToDetail(Action action, Context<ComicSectionState> ctx) async {
  Navigator.of(ctx.context)
      .pushNamed('comic_detail', arguments: action.payload);
}

_startLoad(Action action, Context<ComicSectionState> ctx) async {
  try {
    var loader = GetIt.I;

    var executor = loader.get<DefaultPluginExecutor>();

    var raw = await executor.getRawInfoBy(ctx.state.pluginId);
    var section = await executor.getSections(raw, ctx.state.url);

    ctx.dispatch(ComicSectionActionCreator.finishLoad(section));
  } catch (e) {
    commonErrorHandler(e, ctx);
  }
}

void _init(Action action, Context<ComicSectionState> ctx) {
  ctx.dispatch(ComicSectionActionCreator.startLoad());
}
