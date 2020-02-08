import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/enum/js_engine_type.dart';

import 'action.dart';
import 'state.dart';

Reducer<SettingsState> buildReducer() {
  return asReducer(
    <Object, Reducer<SettingsState>>{
      SettingsAction.engineChange: _onEngineChange,
      SettingsAction.initValue: _onInitValue,
    },
  );
}

SettingsState _onInitValue(SettingsState state, Action action) {
  final SettingsState newState = state.clone();

  if (action.payload == JsEngineType.V8.toString()) {
    newState.jsEngineType = JsEngineType.V8;
  } else {
    newState.jsEngineType = JsEngineType.Rhino;
  }

  return newState;
}

SettingsState _onEngineChange(SettingsState state, Action action) {
  if (state.jsEngineType == action.payload) {
    final SettingsState newState = state.clone();

    if (action.payload == JsEngineType.V8.toString()) {
      newState.jsEngineType = JsEngineType.V8;
    } else {
      newState.jsEngineType = JsEngineType.Rhino;
    }

    return newState;
  } else {
    return state;
  }
}
