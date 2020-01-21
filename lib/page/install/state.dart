import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/plugin_info.dart';

class InstallState implements Cloneable<InstallState> {
  List<PluginInfo> pluginsInfo;
  bool loading = true;

  @override
  InstallState clone() {
    return InstallState()
      ..pluginsInfo = pluginsInfo
      ..loading = loading;
  }
}

InstallState initState(Map<String, dynamic> args) {
  var installState = InstallState();

  installState.pluginsInfo = List();
  installState.loading = true;

  return installState;
}
