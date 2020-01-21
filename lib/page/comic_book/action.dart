import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_book.dart';

enum ComicBookAction { startLoad, finishLoad }

class ComicBookActionCreator {
  static Action startLoad() {
    return const Action(ComicBookAction.startLoad);
  }

  static Action finishLoad(String title, List<ComicBook> list) {
    return Action(ComicBookAction.finishLoad,
        payload: {"name": title, "books": list});
  }
}
