import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HomePageState> buildReducer() {
  return asReducer(
    <Object, Reducer<HomePageState>>{HomeAction.finishLoad: _finishLoad},
  );
}

HomePageState _finishLoad(HomePageState state, Action action) {
  final newState = state.clone();
  newState.plugins = action.payload;
  return newState;
}
