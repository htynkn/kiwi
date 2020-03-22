import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/enum/plugin_provider_type.dart';
import 'package:kiwi/domain/plugin_info.dart';

class InstallState implements Cloneable<InstallState> {
  List<PluginInfo> pluginsInfo;
  String searchKey = "";
  bool loading = true;
  PluginProviderType providerType = PluginProviderType.File;

  @override
  InstallState clone() {
    return InstallState()
      ..pluginsInfo = pluginsInfo
      ..searchKey = searchKey
      ..providerType = providerType
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
