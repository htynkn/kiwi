import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InstallState> buildReducer() {
  return asReducer(
    <Object, Reducer<InstallState>>{
      InstallAction.load: _onLoad,
    },
  );
}

InstallState _onLoad(InstallState state, Action action) {
  final InstallState newState = state.clone();

  newState.pluginsInfo = action.payload;

  return newState;
}
