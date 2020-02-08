import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InstallPage extends Page<InstallState, Map<String, dynamic>> {
  InstallPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<InstallState>(
              adapter: null, slots: <String, Dependent<InstallState>>{}),
          middleware: <Middleware<InstallState>>[],
        );
}
