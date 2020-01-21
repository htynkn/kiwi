import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ComicBookState> buildReducer() {
  return asReducer(
    <Object, Reducer<ComicBookState>>{
      ComicBookAction.finishLoad: _onFinishLoad,
      ComicBookAction.startLoad: _onStartLoad,
    },
  );
}

ComicBookState _onFinishLoad(ComicBookState state, Action action) {
  final ComicBookState newState = state.clone();

  newState.loading = false;
  newState.comicBooks = action.payload["books"];
  newState.name = action.payload["name"];

  return newState;
}

ComicBookState _onStartLoad(ComicBookState state, Action action) {
  final ComicBookState newState = state.clone();

  newState.loading = true;

  return newState;
}
