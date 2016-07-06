package org.boomslang.dsl.feature.ui.highlighting

import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultAntlrTokenToAttributeIdMapper

class AntlrTokenToAttributeIdMapperCustom extends DefaultAntlrTokenToAttributeIdMapper {

	override protected calculateId(String tokenName, int tokenType) {
		if("RULE_ML_DOCUMENTATION".equals(tokenName)) {
			return HighlightingConfigurationCustom::COMMENT_ID;
		}
		super.calculateId(tokenName, tokenType)
	}

}
