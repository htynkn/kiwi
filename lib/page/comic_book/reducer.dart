import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ComicBookState> buildReducer() {
  return asReducer(
    <Object, Reducer<ComicBookState>>{
      ComicBookAction.finishLoad: _onFinishLoad,
      ComicBookAction.startLoad: _onStartLoad,
      ComicBookAction.changeTabIndex: _onChangeTabIndex
    },
  );
}

ComicBookState _onChangeTabIndex(ComicBookState state, Action action) {
  return state.clone()..tabIndex = action.payload;
}

ComicBookState _onFinishLoad(ComicBookState state, Action action) {
  final ComicBookState newState = state.clone();

  newState.loading = false;
  newState.comicBooks = action.payload["books"];
  newState.name = action.payload["name"];
  newState.homeName = action.payload["homeName"];
  newState.tagName = action.payload["tagName"];

  return newState;
}

ComicBookState _onStartLoad(ComicBookState state, Action action) {
  final ComicBookState newState = state.clone();

  newState.loading = true;

  return newState;
}
