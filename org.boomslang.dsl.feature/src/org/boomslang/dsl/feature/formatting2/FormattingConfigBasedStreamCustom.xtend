package org.boomslang.dsl.feature.formatting2

import org.eclipse.xtext.formatting.impl.FormattingConfigBasedStream
import org.eclipse.xtext.parsetree.reconstr.ITokenStream
import org.eclipse.xtext.formatting.impl.FormattingConfig
import org.eclipse.xtext.formatting.IElementMatcherProvider.IElementMatcher
import org.eclipse.xtext.formatting.impl.AbstractFormattingConfig.ElementPattern
import org.eclipse.xtext.parsetree.reconstr.IHiddenTokenHelper
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.AbstractRule
import org.eclipse.xtext.GrammarUtil
import org.eclipse.xtext.TerminalRule
import org.eclipse.xtext.Grammar

/**
 * WIP - the grammar contains a rule (TextToEol) that captures everything until the end of the line
 * which is causes the formatter to behave unexpected
 */
class FormattingConfigBasedStreamCustom extends FormattingConfigBasedStream {

	protected Grammar grammar

	new(ITokenStream out, String initialIndentation, FormattingConfig cfg, IElementMatcher<ElementPattern> matcher,
		IHiddenTokenHelper hiddenTokenHelper, boolean preserveSpaces, Grammar grammar) {
		super(out, initialIndentation, cfg, matcher, hiddenTokenHelper, preserveSpaces)
		this.grammar = grammar
	}
	
//	@Override
//	@SuppressWarnings("deprecation")
//	public void writeHidden(EObject grammarElement, String value) throws IOException {
//		boolean isWhitespace = grammarElement instanceof AbstractRule
//				&& hiddenTokenHelper.isWhitespace((AbstractRule) grammarElement);
//		if (isWhitespace || cfg.getWhitespaceRule() == grammarElement) {
//			if (preservedWS == null)
//				preservedWS = value;
//			else
//				preservedWS += value;
//		} else
//			addLineEntry(grammarElement, value, true);
//	}
	

	override public void writeHidden(EObject grammarElement, String value) {
		val boolean isWhitespace = grammarElement instanceof AbstractRule &&
			hiddenTokenHelper.isWhitespace(grammarElement as AbstractRule);
		if (isWhitespace || isWSRule(grammarElement)) {
			if (preservedWS == null) {

				preservedWS = value;
			} else {
				preservedWS = preservedWS + value;
			}
		} else
			addLineEntry(grammarElement, value, true);
	}

	def protected boolean isWSRule(EObject grammarElement) {
		return (GrammarUtil.findRuleForName(grammar, "WS") as TerminalRule == grammarElement) ||
			(GrammarUtil.findRuleForName(grammar, "NL") as TerminalRule == grammarElement)
	}

}
