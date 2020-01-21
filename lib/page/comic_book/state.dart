import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/comic_book.dart';

class ComicBookState implements Cloneable<ComicBookState> {
  int pluginId;

  List<ComicBook> comicBooks;

  @override
  ComicBookState clone() {
    return ComicBookState()..pluginId = pluginId;
  }
}

ComicBookState initState(Map<String, dynamic> args) {
  var comicBookState = ComicBookState();

  comicBookState.pluginId = args["pluginId"];
  comicBookState.comicBooks = List();

  return comicBookState;
}
