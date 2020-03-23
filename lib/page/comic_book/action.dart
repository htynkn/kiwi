import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_book.dart';
import 'package:kiwi/domain/comic_tags.dart';

enum ComicBookAction { startLoad, finishLoad, jumpToSection, changeTabIndex }

class ComicBookActionCreator {
  static Action startLoad() {
    return const Action(ComicBookAction.startLoad);
  }

  static Action finishLoad(String name, String homeName, String tagName,
      List<ComicBook> list, ComicTags tags) {
    return Action(ComicBookAction.finishLoad, payload: {
      "name": name,
      "homeName": homeName,
      "tagName": tagName,
      "tags": tags,
      "books": list
    });
  }

  static Action jumpToSection(
      int pluginId, String url, String logo, String name) {
    return Action(ComicBookAction.jumpToSection, payload: {
      "pluginId": pluginId,
      "url": url,
      "logo": logo,
      "name": name
    });
  }

  static Action changeTabIndex(int value) {
    return Action(ComicBookAction.changeTabIndex, payload: value);
  }
}
