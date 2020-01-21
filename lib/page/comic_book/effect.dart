import 'package:fish_redux/fish_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:kiwi/service/default_plugin_executor.dart';

import 'action.dart';
import 'state.dart';

Effect<ComicBookState> buildEffect() {
  return combineEffects(<Object, Effect<ComicBookState>>{
    Lifecycle.initState: _init,
    ComicBookAction.startLoad: _startLoad,
  });
}

_init(Action action, Context<ComicBookState> ctx) {
  ctx.dispatch(ComicBookActionCreator.startLoad());
}

_startLoad(Action action, Context<ComicBookState> ctx) async {
  var defaultPluginExecutor = GetIt.I.get<DefaultPluginExecutor>();

  var raw = await defaultPluginExecutor.getRawInfoBy(ctx.state.pluginId);

  var list = await defaultPluginExecutor.getComicBooks(raw);

  ctx.dispatch(ComicBookActionCreator.finishLoad(list));
}
