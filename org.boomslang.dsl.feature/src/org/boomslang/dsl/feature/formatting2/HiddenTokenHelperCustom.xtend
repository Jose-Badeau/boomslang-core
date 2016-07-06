package org.boomslang.dsl.feature.formatting2

import com.google.inject.Inject
import org.eclipse.xtext.AbstractRule
import org.eclipse.xtext.GrammarUtil
import org.eclipse.xtext.IGrammarAccess
import org.eclipse.xtext.ParserRule
import org.eclipse.xtext.parsetree.reconstr.impl.DefaultHiddenTokenHelper

/**
 * WIP - the grammar contains a rule (TextToEol) that captures everything until the end of the line
 * which is causes the formatter to behave unexpected
 */
class HiddenTokenHelperCustom extends DefaultHiddenTokenHelper {
	
	private AbstractRule wsRule;
	
	private AbstractRule nlRule;
	
	override public boolean isWhitespace(AbstractRule rule) {
		return rule != null && ("WS".equals(rule.getName()) || "NL".equals(rule.name))
	}
	
	@Inject
	def private void setGrammar(IGrammarAccess grammar) {
		wsRule = GrammarUtil.findRuleForName(grammar.getGrammar(), "WS");
		nlRule = GrammarUtil.findRuleForName(grammar.getGrammar(), "NL");
	}
	
	
	override public AbstractRule getWhitespaceRuleFor(ParserRule context, String whitespace) {
		if (whitespace == null) {
			return null
		}
		if (whitespace.contains(" ") || whitespace.contains("\t")) {
			return wsRule
		}
		if (whitespace.contains("\r") || whitespace.contains("\n")) {
			return nlRule
		}
		return null
	}

}
