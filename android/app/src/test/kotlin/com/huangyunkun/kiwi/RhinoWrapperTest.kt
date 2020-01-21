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
}
