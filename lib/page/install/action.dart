import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/plugin_info.dart';

enum InstallAction { load, install, finishInstall, search }

class InstallActionCreator {
  static Action loadFinish(String keyWord, List<PluginInfo> list) {
    return Action(InstallAction.load,
        payload: {"keyWord": keyWord, "list": list});
  }

  static Action install(Map<String, String> map) {
    return Action(InstallAction.install, payload: map);
  }

  static Action finishInstall(Map<String, Object> map) {
    return Action(InstallAction.finishInstall, payload: map);
  }

  static Action search(String searchText) {
    return Action(InstallAction.search, payload: searchText);
  }
}
