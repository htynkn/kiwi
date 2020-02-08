import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/plugin_info.dart';

class InstallState implements Cloneable<InstallState> {
  List<PluginInfo> pluginsInfo;
  String searchKey = "";
  bool loading = true;

  @override
  InstallState clone() {
    return InstallState()
      ..pluginsInfo = pluginsInfo
      ..searchKey = searchKey
      ..loading = loading;
  }
}

InstallState initState(Map<String, dynamic> args) {
  var installState = InstallState();

  installState.pluginsInfo = List();
  installState.loading = true;
  installState.searchKey = "";

  return installState;
}
