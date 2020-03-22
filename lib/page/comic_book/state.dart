import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_book.dart';
import 'package:kiwi/domain/comic_tags.dart';

class ComicBookState implements Cloneable<ComicBookState> {
  int pluginId;
  String name;
  List<ComicBook> comicBooks;
  ComicTags comicTags;
  bool loading = true;
  String homeName;
  String tagName;
  int tabIndex = 0;

  @override
  ComicBookState clone() {
    return ComicBookState()
      ..pluginId = pluginId
      ..name = name
      ..loading = loading
      ..homeName = homeName
      ..tagName = tagName
      ..tabIndex = tabIndex
      ..comicTags = comicTags
      ..comicBooks = comicBooks;
  }
}

ComicBookState initState(Map<String, dynamic> args) {
  var comicBookState = ComicBookState();

  comicBookState.pluginId = args["pluginId"];
  comicBookState.comicBooks = List();
  comicBookState.comicTags = ComicTags();
  comicBookState.name = "";

  return comicBookState;
}
