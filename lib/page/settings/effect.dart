import 'package:fish_redux/fish_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'action.dart';
import 'state.dart';

Effect<SettingsState> buildEffect() {
  return combineEffects(<Object, Effect<SettingsState>>{
    Lifecycle.initState: _onInitState,
    SettingsAction.engineChange: _onEngineChange,
  });
}

Future<void> _onInitState(Action action, Context<SettingsState> ctx) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String jsEngineValue = prefs.getString("jsEngine");

  ctx.dispatch(SettingsActionCreator.initValue(jsEngineValue));
}

Future<void> _onEngineChange(Action action, Context<SettingsState> ctx) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jsEngine', action.payload.toString());
}
