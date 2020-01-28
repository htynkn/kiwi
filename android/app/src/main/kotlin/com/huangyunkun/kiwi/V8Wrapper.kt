package com.huangyunkun.kiwi

import com.eclipsesource.v8.V8


class V8Wrapper {
    fun executeJs(script: String, method: String): String {
        val runtime = V8.createV8Runtime()

        val result = runtime.executeScript("$script;$method").toString()

        runtime.release()

        return result;
    }

    fun executeJsWithContext(script: String, method: String, map: Map<String, Any>): String {
        val runtime = V8.createV8Runtime()

        for (entry in map) {
            if (entry.value is Int) {
                runtime.add(entry.key, entry.value as Int);
            } else {
                runtime.add(entry.key, entry.value.toString());
            }
        }

        val result = runtime.executeScript("$script;$method").toString()

        runtime.release()

        return result;
    }
}
