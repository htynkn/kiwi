import 'package:fish_redux/fish_redux.dart';

class ComicDetailState implements Cloneable<ComicDetailState> {
  List<String> pics;
  int pluginId;
  String url;
  bool loading = true;
  String sectionName;
  String ua;
  String reference;

  Duration duration;

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
      ..url = url;
  }
}

ComicDetailState initState(Map<String, dynamic> args) {
  var comicDetailState = ComicDetailState();

  comicDetailState.pluginId = args["pluginId"];
  comicDetailState.url = args["url"];
  comicDetailState.loading = true;
  comicDetailState.sectionName = args["sectionName"];

  return comicDetailState;
}
