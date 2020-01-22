import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ComicDetailPage extends Page<ComicDetailState, Map<String, dynamic>> {
  ComicDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ComicDetailState>(
                adapter: null,
                slots: <String, Dependent<ComicDetailState>>{
                }),
            middleware: <Middleware<ComicDetailState>>[
            ],);

}
