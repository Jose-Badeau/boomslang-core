package org.boomslang.generator.util

import org.boomslang.dsl.feature.feature.BAssertionComponentActionParameter
import org.boomslang.dsl.feature.feature.BCodeStatement
import org.boomslang.dsl.feature.feature.BCommandComponentActionParameter
import org.boomslang.dsl.feature.feature.BToScreenSwitch
import org.eclipse.xtend.lib.Property

import static org.boomslang.generator.util.BGeneratorWhenThenAnd.*

/**
 * Statemachine to determine which of the "when", "then" or "and" sections
 * should be generated in the Groovy class.
 */
class CodeSectionStatemachine {

	/** the current section, "when", "then" or "and" */
	@Property BGeneratorWhenThenAnd state

	def resetSection() {
		state = BGeneratorWhenThenAnd.ASSERTION_SECTION_TAIL
		return this
	}

	/**
	 * @param currentStatement The current code statement will be 
	 * used to compute the section ("when", "then" or "and")  
	 * which we are in and from this the appropriate section header
	 * like "when:", "then:" or "and:"
	 */
	def CharSequence computeSectionHeader(BCodeStatement currentStatement) {
		switch (currentStatement) {
			BAssertionComponentActionParameter: {
				switch (getState) {
					case COMMAND_SECTION_HEAD: state = ASSERTION_SECTION_HEAD
					case COMMAND_SECTION_TAIL: state = ASSERTION_SECTION_HEAD
					case ASSERTION_SECTION_HEAD: state = ASSERTION_SECTION_TAIL
					case ASSERTION_SECTION_TAIL: state = ASSERTION_SECTION_TAIL
				}
			}
			BCommandComponentActionParameter: {
				switch (getState) {
					case COMMAND_SECTION_HEAD: state = COMMAND_SECTION_TAIL
					case COMMAND_SECTION_TAIL: state = COMMAND_SECTION_TAIL
					case ASSERTION_SECTION_HEAD: state = COMMAND_SECTION_HEAD
					case ASSERTION_SECTION_TAIL: state = COMMAND_SECTION_HEAD
				}
			}
			
			BToScreenSwitch: {
				switch (getState) {
					case COMMAND_SECTION_HEAD: state = ASSERTION_SECTION_HEAD
					case COMMAND_SECTION_TAIL: state = ASSERTION_SECTION_HEAD
					case ASSERTION_SECTION_HEAD: state = ASSERTION_SECTION_TAIL
					case ASSERTION_SECTION_TAIL: state = ASSERTION_SECTION_TAIL
				}
			}
		}
		switch (currentStatement){
		default:{
        		switch (getState) {
        			case COMMAND_SECTION_HEAD:   return '''
        												
        												when:'''
        			
        			case COMMAND_SECTION_TAIL:   return '''and:'''
        			
        			case ASSERTION_SECTION_HEAD: return '''
        												
        												then:'''
        			
        			case ASSERTION_SECTION_TAIL: return '''and:'''
        		}
       		}
       	}
	}
}
