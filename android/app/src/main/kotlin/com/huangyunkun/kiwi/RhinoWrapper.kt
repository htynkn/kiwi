package com.huangyunkun.kiwi

import org.mozilla.javascript.Context


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

}
