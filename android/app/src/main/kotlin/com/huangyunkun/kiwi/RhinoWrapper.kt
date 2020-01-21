package com.huangyunkun.kiwi

import org.mozilla.javascript.Context
import java.util.*


class RhinoWrapper {
    fun executeJs(script: String, method: String): String {
        try {
            val cx = Context.enter()
            cx.optimizationLevel = -1;

            val scope = cx.initStandardObjects()

            val result = cx.evaluateString(scope, "$script;$method", null, 1, null)

            return result.toString()
        } finally {
            Context.exit();
        }
    }

    fun executeJsWithContext(script: String, method: String, map: Map<String, Any>): String {
        try {
            val cx = Context.enter()
            cx.optimizationLevel = -1;

            val scope = cx.initStandardObjects()

            for (entry in map.entries) {
                scope.put(entry.key, scope, entry.value);
            }

            val result = cx.evaluateString(scope, "$script;$method", null, 1, null)

            return result.toString()
        } finally {
            Context.exit();
        }
    }

}
