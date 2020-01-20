import 'package:kiwi/domain/plugin_info.dart';
import 'package:fish_redux/fish_redux.dart';

class InstallState implements Cloneable<InstallState> {
  List<PluginInfo> pluginsInfo;

  @override
  InstallState clone() {
    return InstallState()..pluginsInfo = pluginsInfo;
  }
}

InstallState initState(Map<String, dynamic> args) {
  var installState = InstallState();

  installState.pluginsInfo = List();

  return installState;
}
