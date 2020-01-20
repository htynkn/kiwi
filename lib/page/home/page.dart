import 'package:duoduo_cat/page/home/effect.dart';
import 'package:duoduo_cat/page/home/reducer.dart';
import 'package:fish_redux/fish_redux.dart';

import 'state.dart';
import 'view.dart';

class HomePage extends Page<HomePageState, Map<String, dynamic>> {
  HomePage()
      : super(
            initState: initState,
            view: buildView,
            reducer: buildReducer(),
            effect: buildEffect(),
            dependencies: Dependencies<HomePageState>(
                adapter: null, slots: <String, Dependent<HomePageState>>{}),
            middleware: <Middleware<HomePageState>>[]);
}
