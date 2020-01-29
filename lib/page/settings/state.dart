import 'package:fish_redux/fish_redux.dart';
import 'package:kiwi/domain/enum/js_engine_type.dart';

class SettingsState implements Cloneable<SettingsState> {
  JsEngineType jsEngineType;

  @override
  SettingsState clone() {
    return SettingsState()..jsEngineType = jsEngineType;
  }
}

SettingsState initState(Map<String, dynamic> args) {
  var settingsState = SettingsState();

  return settingsState;
}
