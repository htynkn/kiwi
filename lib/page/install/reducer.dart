import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InstallState> buildReducer() {
  return asReducer(
    <Object, Reducer<InstallState>>{
      InstallAction.load: _onLoad,
      InstallAction.search: _onSearch,
    },
  );
}

InstallState _onSearch(InstallState state, Action action) {
  return state.clone()
    ..loading = true
    ..searchKey = action.payload;
}

InstallState _onLoad(InstallState state, Action action) {
  final InstallState newState = state.clone();

  newState.pluginsInfo = action.payload;
  newState.loading = false;

  return newState;
}
