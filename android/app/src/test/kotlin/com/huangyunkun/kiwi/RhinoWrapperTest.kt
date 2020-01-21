package com.huangyunkun.kiwi

import org.hamcrest.CoreMatchers
import org.junit.Assert.assertThat
import org.junit.Test

class RhinoWrapperTest {
    @Test
    fun runScript() {
        val rhinoWrapper = RhinoWrapper()

        val result = rhinoWrapper.executeJs("var c = function(a,b) { return a+b;}", "c(1,2)");

        assertThat(result, CoreMatchers.`is`("3.0"));
    }

    @Test
    fun runWithContext() {
        val rhinoWrapper = RhinoWrapper()

        var map = HashMap<String, Any>();

        map.put("x", 1);
        map.put("y", 2);

        val result = rhinoWrapper.executeJsWithContext("var c = function(a,b) { return a+b;}", "c(x,y)", map);

        assertThat(result, CoreMatchers.`is`("3.0"));
    }
}
