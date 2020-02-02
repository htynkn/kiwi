import 'package:fish_redux/fish_redux.dart';

class ComicSectionState implements Cloneable<ComicSectionState> {
  String url;
  int pluginId;
  String pluginName;
  String name;
  String author;
  String intro;
  String logo;
  int isSectionsAsc;
  List<ComicSectionDetailState> sections;

  bool loading = true;

  @override
  ComicSectionState clone() {
    return ComicSectionState()
      ..url = url
      ..name = name
      ..author = author
      ..intro = intro
      ..logo = logo
      ..isSectionsAsc = isSectionsAsc
      ..sections = sections
      ..loading = loading
      ..pluginName = pluginName
      ..pluginId = pluginId;
  }
}

class ComicSectionDetailState implements Cloneable<ComicSectionState> {
  String name;
  String url;

  @override
  ComicSectionState clone() {
    return ComicSectionState()
      ..name = name
      ..url = url;
  }
}

ComicSectionState initState(Map<String, dynamic> args) {
  var comicSectionState = ComicSectionState();

  comicSectionState.url = args["url"];
  comicSectionState.pluginId = args["pluginId"];

  comicSectionState.sections = List();
  comicSectionState.loading = true;

  comicSectionState.logo = args["logo"];
  comicSectionState.name = args["name"];

  comicSectionState.pluginName = "";

  return comicSectionState;
}
