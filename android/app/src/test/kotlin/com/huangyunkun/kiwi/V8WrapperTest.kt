package com.huangyunkun.kiwi

import org.hamcrest.CoreMatchers
import org.junit.Assert.assertThat
import org.junit.Test

class V8WrapperTest {
    @Test
    fun runScript() {
        val v8Wrapper = V8Wrapper()

        val result = v8Wrapper.executeJs("var c = function(a,b) { return a+b;}", "c(1,2)");

        assertThat(result, CoreMatchers.`is`("3"));
    }

    @Test
    fun runWithContext() {
        val v8Wrapper = V8Wrapper()

        var map = HashMap<String, Any>();

        map.put("x", 1);
        map.put("y", 2);

        val result = v8Wrapper.executeJsWithContext("var c = function(a,b) { return a+b;}", "c(x,y)", map);

        assertThat(result, CoreMatchers.`is`("3"));
    }
}
