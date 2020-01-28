import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_detail.dart';
import 'package:kiwi/domain/enum/comic_detail_direction.dart';

import 'action.dart';
import 'state.dart';

Reducer<ComicDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<ComicDetailState>>{
      ComicDetailAction.startLoad: _onStartLoad,
      ComicDetailAction.finishLoad: _onFinishLoad,
      ComicDetailAction.changePageIndex: _onChangePageIndex,
      ComicDetailAction.changeDirection: _onChangeDirection,
    },
  );
}

ComicDetailState _onChangeDirection(ComicDetailState state, Action action) {
  var newState = state.clone();

  if (action.payload == ComicDetailDirection.CROSS.toString()) {
    newState.direction = ComicDetailDirection.CROSS;
  } else {
    newState.direction = ComicDetailDirection.VERTICAL;
  }

  return newState;
}

ComicDetailState _onChangePageIndex(ComicDetailState state, Action action) {
  int pageIndex = action.payload;
  if (state.currentPageIndex != pageIndex) {
    return state.clone()..currentPageIndex = pageIndex;
  }
  return state;
}

ComicDetailState _onStartLoad(ComicDetailState state, Action action) {
  return state.clone()..loading = true;
}

ComicDetailState _onFinishLoad(ComicDetailState state, Action action) {
  final ComicDetailState newState = state.clone();

  ComicDetail detail = action.payload;

  newState.loading = false;
  newState.reference = detail.reference;
  newState.ua = detail.ua;
  newState.pics = detail.pics;
  newState.duration = detail.duration;

  return newState;
}
