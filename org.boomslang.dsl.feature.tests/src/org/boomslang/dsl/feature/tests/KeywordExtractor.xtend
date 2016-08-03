package org.boomslang.dsl.feature.tests

import com.google.inject.Inject
import org.boomslang.dsl.feature.services.FeatureGrammarAccess
import org.eclipse.xtext.GrammarUtil
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

/**
 * If keywords should be allowed in Xtext grammar rules, e.g. for 
 * package names or wiki-style text, they have to be explicitly mentioned in the rule.
 * 
 * This is an utility to extract keywords from an Xtext grammar file.
 * It could as well be written as a regular Java class, it just happened
 * to be written as JUnit test because of the convenient syntax.
 */
@InjectWith(FeatureInjectorProviderCustom)
@RunWith(XtextRunner)
class KeywordExtractor {
	
	@Inject FeatureGrammarAccess ga
	
	/**
		Word:
		 	IdOrKeyword |
			INT |
			STRING |
			ML_COMMENT |
			SL_COMMENT |
			ANY_OTHER
		;
		
		IdOrKeyword :
			ID |
			Keyword
		;
	*/
	@Test
	def void printKeywords() {
		val keywords = GrammarUtil.getAllKeywords(ga.grammar)
				println(
			'''
				Keyword:
					«FOR keyword : keywords.sortBy[it.toLowerCase].toList SEPARATOR ''' |'''»
						'«keyword»'
					«ENDFOR»
				;
				
			'''
		)
	}
	
}