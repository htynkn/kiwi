import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ComicSectionPage extends Page<ComicSectionState, Map<String, dynamic>> {
  ComicSectionPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ComicSectionState>(
              adapter: null, slots: <String, Dependent<ComicSectionState>>{}),
          middleware: <Middleware<ComicSectionState>>[],
        );
}
