package com.huangyunkun.kiwi

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.huangyunkun.kiwi/jsEngine"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "executeJs") {
                val wrapper = RhinoWrapper();
                val script = call.argument<String>("script").orEmpty();
                val method = call.argument<String>("method").orEmpty();

                if (script != "" && method != "") {
                    result.success(wrapper.executeJs(script, method));
                } else {
                    result.error("1", "invalid parameter", call.toString())
                }
            } else if (call.method == "executeJsWithContext") {
                val wrapper = RhinoWrapper();
                val script = call.argument<String>("script").orEmpty();
                val method = call.argument<String>("method").orEmpty();
                val context = call.argument<Map<String, Any>>("context").orEmpty();

                if (script != "" && method != "") {
                    result.success(wrapper.executeJsWithContext(script, method, context));
                } else {
                    result.error("1", "invalid parameter", call.toString())
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
