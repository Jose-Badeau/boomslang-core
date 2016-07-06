package org.boomslang.generator.util

import org.boomslang.dsl.feature.feature.BIntOrParam
import org.boomslang.dsl.feature.feature.BStringOrParam
import com.wireframesketcher.model.Item
import com.wireframesketcher.model.Screen
import com.wireframesketcher.model.Widget

/**
 * Common methods for the feature generators
 */
class BGeneratorUtil {

    /** 
     * @return if the parameter is not empty, it is returned, i.e.
     * the text String is considered irrelevant then
     * 
     * A valid model only has either param or text set, but not both 
     */
    def compileStringOrParam(BStringOrParam it) '''«IF param != null»«param.name»«ELSE»"«it.text»"«ENDIF»'''

    def compileIntOrParam(BIntOrParam it) '''«IF param != null»«param.name»«ELSE»«it.int»«ENDIF»'''

    def getScreenForWidget(Widget widget) {
        if (widget.container instanceof Screen) {
            return widget.container as Screen
        }

    }

    def extractVariableName(Screen screen) {
        val name = screen.name
        name.substring(name.lastIndexOf(".") + 1).toFirstLower + "Screen"
    }
    
    //FIXME: Why is the tab name not loaded?
    def getTabName(Item it){
        var start= toString.lastIndexOf("#")+1
        var end= toString.lastIndexOf(")")
        if(start==0 ){
            start= toString.lastIndexOf("name: ")+7
            end= toString.indexOf(")")
            return name
        }
        toString.substring(start,end)
    }
    
    def toCamelCase(String it){
        val builder=new StringBuilder();
        split(" ").forEach[builder.append(it.replaceAll("[^a-zA-Z0-9]+","").toFirstUpper)]
        return builder.toString.toFirstLower.trim
        
    }
    
}