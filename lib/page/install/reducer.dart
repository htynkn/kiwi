import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InstallState> buildReducer() {
  return asReducer(
    <Object, Reducer<InstallState>>{
      InstallAction.finishLoad: _onFinishLoad,
      InstallAction.startSwitchProvider: _onStartSwitch
    },
  );
}

InstallState _onStartSwitch(InstallState state, Action action) {
  final InstallState newState = state.clone();

  newState.providerType = action.payload;
  newState.pluginsInfo = List();
  newState.loading = true;

  return newState;
}

InstallState _onFinishLoad(InstallState state, Action action) {
  final InstallState newState = state.clone();

  newState.pluginsInfo = action.payload["list"];
  newState.searchKey = action.payload["keyWord"];
  if (action.payload["type"] != null) {
    newState.providerType = action.payload["type"];
  }
  newState.loading = false;

  return newState;
}
