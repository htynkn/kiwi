import 'package:duoduo_cat/domain/plugin.dart';
import 'package:fish_redux/fish_redux.dart';

enum HomeAction { finishLoad, jumpToInstall, reload, startLoad }

class HomeActionCreator {
  static Action finishLoadPlugin(List<Plugin> plugins) {
    return Action(HomeAction.finishLoad, payload: plugins);
  }

  static Action jumpToInstall() {
    return const Action(HomeAction.jumpToInstall);
  }

  static Action reload() {
    return const Action(HomeAction.reload);
  }

  static Action startLoad() {
    return const Action(HomeAction.startLoad);
  }
}
