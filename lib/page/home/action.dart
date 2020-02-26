import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/plugin.dart';

enum HomeAction {
  finishLoad,
  jumpToInstall,
  reload,
  startLoad,
  clickBook,
  deletePlugin
}

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

  static Action clickBook(int pluginId) {
    return Action(HomeAction.clickBook, payload: pluginId);
  }

  static Action deletePlugin(int pluginId) {
    return Action(HomeAction.deletePlugin, payload: pluginId);
  }
}
