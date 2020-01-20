import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HomePageState> buildReducer() {
  return asReducer(
    <Object, Reducer<HomePageState>>{HomeAction.load: _load},
  );
}

HomePageState _load(HomePageState state, Action action) {
  return state;
}
