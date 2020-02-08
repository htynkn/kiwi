package com.huangyunkun.kiwi

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.huangyunkun.kiwi/rhinoJsEngine"
    private val V8_CHANNEL = "com.huangyunkun.kiwi/v8JsEngine"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val rhinoWrapper = RhinoWrapper();

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "executeJs") {
                val script = call.argument<String>("script").orEmpty();
                val method = call.argument<String>("method").orEmpty();

                if (script != "" && method != "") {
                    result.success(rhinoWrapper.executeJs(script, method));
                } else {
                    result.error("1", "invalid parameter", call.toString())
                }
            } else if (call.method == "executeJsWithContext") {
                val script = call.argument<String>("script").orEmpty();
                val method = call.argument<String>("method").orEmpty();
                val context = call.argument<Map<String, Any>>("context").orEmpty();

                if (script != "" && method != "") {
                    result.success(rhinoWrapper.executeJsWithContext(script, method, context));
                } else {
                    result.error("1", "invalid parameter", call.toString())
                }
            } else {
                result.notImplemented()
            }
        }

        val v8Wrapper = V8Wrapper();

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, V8_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "executeJs") {
                val script = call.argument<String>("script").orEmpty();
                val method = call.argument<String>("method").orEmpty();

                if (script != "" && method != "") {
                    result.success(v8Wrapper.executeJs(script, method));
                } else {
                    result.error("1", "invalid parameter", call.toString())
                }
            } else if (call.method == "executeJsWithContext") {
                val script = call.argument<String>("script").orEmpty();
                val method = call.argument<String>("method").orEmpty();
                val context = call.argument<Map<String, Any>>("context").orEmpty();

                if (script != "" && method != "") {
                    result.success(v8Wrapper.executeJsWithContext(script, method, context));
                } else {
                    result.error("1", "invalid parameter", call.toString())
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
