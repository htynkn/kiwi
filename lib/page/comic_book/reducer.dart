import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ComicBookState> buildReducer() {
  return asReducer(
    <Object, Reducer<ComicBookState>>{
      ComicBookAction.finishLoad: _onFinishLoad,
    },
  );
}

ComicBookState _onFinishLoad(ComicBookState state, Action action) {
  final ComicBookState newState = state.clone();

  newState.comicBooks = action.payload;

  return newState;
}
