import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/enum/comic_detail_direction.dart';

class ComicDetailState implements Cloneable<ComicDetailState> {
  List<String> pics;
  int pluginId;
  String url;
  bool loading = true;
  String sectionName;
  String ua;
  String reference;

  Duration duration;

  int currentPageIndex;
  ComicDetailDirection direction;

  @override
  ComicDetailState clone() {
    return ComicDetailState()
      ..pics = pics
      ..loading = loading
      ..pluginId = pluginId
      ..sectionName = sectionName
      ..ua = ua
      ..reference = reference
      ..duration = duration
      ..currentPageIndex = currentPageIndex
      ..direction = direction
      ..url = url;
  }
}

ComicDetailState initState(Map<String, dynamic> args) {
  var comicDetailState = ComicDetailState();

  comicDetailState.pluginId = args["pluginId"];
  comicDetailState.url = args["url"];
  comicDetailState.loading = true;
  comicDetailState.sectionName = args["sectionName"];
  comicDetailState.currentPageIndex = 1;
  comicDetailState.direction = ComicDetailDirection.CROSS;

  return comicDetailState;
}
