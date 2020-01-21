import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_book.dart';

class ComicBookState implements Cloneable<ComicBookState> {
  int pluginId;
  String name;
  List<ComicBook> comicBooks;
  bool loading = true;

  @override
  ComicBookState clone() {
    return ComicBookState()
      ..pluginId = pluginId
      ..name = name
      ..comicBooks = comicBooks;
  }
}

ComicBookState initState(Map<String, dynamic> args) {
  var comicBookState = ComicBookState();

  comicBookState.pluginId = args["pluginId"];
  comicBookState.comicBooks = List();
  comicBookState.name = "";

  return comicBookState;
}
