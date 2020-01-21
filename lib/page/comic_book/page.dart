import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ComicBookPage extends Page<ComicBookState, Map<String, dynamic>> {
  ComicBookPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ComicBookState>(
                adapter: null,
                slots: <String, Dependent<ComicBookState>>{
                }),
            middleware: <Middleware<ComicBookState>>[
            ],);

}
