import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_section.dart';
import 'package:quiver/strings.dart';

import 'action.dart';
import 'state.dart';

ComicSectionState _onFinishLoad(ComicSectionState state, Action action) {
  final ComicSectionState newState = state.clone();

  newState.loading = false;
  ComicSection section = action.payload;

  if (isNotEmpty(section.logo)) {
    newState.logo = section.logo;
  }

  newState.name = section.name;
  newState.author = section.author;
  newState.intro = section.intro;
  newState.isSectionsAsc = section.isSectionsAsc;

  newState.pluginName = section.pluginName;

  newState.sections = section.sections.map(((input) {
    var detail = ComicSectionDetailState();

    detail.name = input.name;
    detail.url = input.url;

    return detail;
  })).toList();

  return newState;
}

Reducer<ComicSectionState> buildReducer() {
  return asReducer(
    <Object, Reducer<ComicSectionState>>{
      ComicSectionAction.startLoad: _onStartLoad,
      ComicSectionAction.finishLoad: _onFinishLoad,
    },
  );
}

ComicSectionState _onStartLoad(ComicSectionState state, Action action) {
  final ComicSectionState newState = state.clone();

  newState.loading = true;

  return newState;
}
