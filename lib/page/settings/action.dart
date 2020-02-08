import 'package:fish_redux/fish_redux.dart';

enum SettingsAction { engineChange, initValue }

class SettingsActionCreator {
  static Action onEngineChange(String value) {
    return Action(SettingsAction.engineChange, payload: value);
  }

  static Action initValue(String jsEngine) {
    return Action(SettingsAction.initValue, payload: jsEngine);
  }
}
