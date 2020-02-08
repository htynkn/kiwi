import 'package:fish_redux/fish_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:kiwi/service/default_plugin_executor.dart';

import '../../error.dart';
import 'action.dart';
import 'state.dart';

Effect<ComicDetailState> buildEffect() {
  return combineEffects(<Object, Effect<ComicDetailState>>{
    Lifecycle.initState: _init,
    ComicDetailAction.startLoad: _onStartLoad,
  });
}

void _init(Action action, Context<ComicDetailState> ctx) {
  Future.delayed(Duration(milliseconds: 100), () {
    ctx.dispatch(ComicDetailActionCreator.startLoad());
  });
}

_onStartLoad(Action action, Context<ComicDetailState> ctx) async {
  try {
    var pluginExecutor = GetIt.I.get<DefaultPluginExecutor>();

    var pluginInfo = await pluginExecutor.getRawInfoBy(ctx.state.pluginId);

    var comicDetail =
        await pluginExecutor.getComicDetails(pluginInfo, ctx.state.url);

    ctx.dispatch(ComicDetailActionCreator.finishLoad(comicDetail));
  } catch (e) {
    commonErrorHandler(e, ctx);
  }
}
