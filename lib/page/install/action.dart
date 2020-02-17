import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/enum/plugin_provider_type.dart';
import 'package:kiwi/domain/plugin_info.dart';

enum InstallAction {
  finishLoad,
  install,
  finishInstall,
  search,
  switchProvider,
  startSwitchProvider
}

class InstallActionCreator {
  static Action loadFinish(String keyWord, List<PluginInfo> list,
      {PluginProviderType type}) {
    return Action(InstallAction.finishLoad,
        payload: {"keyWord": keyWord, "list": list, "type": type});
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

  static Action switchProvider(PluginProviderType type) {
    return Action(InstallAction.switchProvider, payload: type);
  }

  static Action startSwitchProvider(PluginProviderType type) {
    return Action(InstallAction.startSwitchProvider, payload: type);
  }
}
