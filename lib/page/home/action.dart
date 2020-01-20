import 'package:duoduo_cat/domain/plugin.dart';
import 'package:fish_redux/fish_redux.dart';

enum HomeAction { load, jumpToInstall }

class HomeActionCreator {
  static Action loadPlugin(List<Plugin> plugins) {
    return Action(HomeAction.load, payload: plugins);
  }

  static Action jumpToInstall() {
    return const Action(HomeAction.jumpToInstall);
  }
}
