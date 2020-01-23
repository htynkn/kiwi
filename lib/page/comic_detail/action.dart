import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_detail.dart';

enum ComicDetailAction { startLoad, finishLoad, changePageIndex }

class ComicDetailActionCreator {
  static Action startLoad() {
    return const Action(ComicDetailAction.startLoad);
  }

  static Action finishLoad(ComicDetail comicDetail) {
    return Action(ComicDetailAction.finishLoad, payload: comicDetail);
  }

  static changePageIndex(int index) {
    return Action(ComicDetailAction.changePageIndex, payload: index + 1);
  }
}
