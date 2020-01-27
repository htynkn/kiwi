import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_section.dart';

enum ComicSectionAction { startLoad, finishLoad, jumpToDetail, changeOrder }

class ComicSectionActionCreator {
  static Action startLoad() {
    return const Action(ComicSectionAction.startLoad);
  }

  static Action finishLoad(ComicSection section) {
    return Action(ComicSectionAction.finishLoad, payload: section);
  }

  static jumpToDetail(int pluginId, String url, String sectionName) {
    return Action(ComicSectionAction.jumpToDetail, payload: {
      "pluginId": pluginId,
      "url": url,
      "sectionName": sectionName
    });
  }

  static changeOrder() {
    return const Action(ComicSectionAction.changeOrder);
  }
}
