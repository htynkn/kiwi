import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InstallState> buildReducer() {
  return asReducer(
    <Object, Reducer<InstallState>>{
      InstallAction.load: _onLoad,
      InstallAction.switchProvider: _onSwitchProvider,
    },
  );
}

InstallState _onSwitchProvider(InstallState state, Action action) {
  final InstallState newState = state.clone();

  newState.providerType = action.payload;

  return newState;
}

InstallState _onLoad(InstallState state, Action action) {
  final InstallState newState = state.clone();

  newState.pluginsInfo = action.payload["list"];
  newState.searchKey = action.payload["keyWord"];
  newState.loading = false;

  return newState;
}
