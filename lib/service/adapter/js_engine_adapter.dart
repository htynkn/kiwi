import 'package:get_it/get_it.dart';
import 'package:kiwi/core/js_engine_service.dart';
import 'package:kiwi/domain/constant/settings_key.dart';
import 'package:kiwi/domain/enum/js_engine_type.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

class JsEngineAdapter extends JsEngineService {
  @override
  Future<String> executeJs(String script, String method) async {
    var jsEngine = await _chooseJsEngine();
    return jsEngine.executeJs(script, method);
  }

  @override
  Future<String> executeJsWithContext(
      String script, String method, Map<String, dynamic> context) async {
    var jsEngine = await _chooseJsEngine();
    return jsEngine.executeJsWithContext(script, method, context);
  }

  Future<JsEngineService> _chooseJsEngine() async {
    var jsEngine = await Settings()
        .getString(SettingsKey.JS_ENGINE, JsEngineType.V8.toString());
    var jsEngineService = GetIt.I.get<JsEngineService>(jsEngine);
    return jsEngineService;
  }
}
