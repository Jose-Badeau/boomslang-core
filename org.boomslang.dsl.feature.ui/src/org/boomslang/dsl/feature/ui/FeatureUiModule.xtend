/*
 * generated by Xtext 2.10.0
 */
package org.boomslang.dsl.feature.ui

import org.boomslang.dsl.feature.ui.highlighting.AntlrTokenToAttributeIdMapperCustom
import org.boomslang.dsl.feature.ui.highlighting.HighlightingConfigurationCustom
import org.boomslang.dsl.feature.ui.highlighting.SemanticHighlightingCalculator
import org.eclipse.core.resources.IWorkspaceRoot
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration

/**
 * Use this class to register components to be used within the Eclipse IDE.
 */
@FinalFieldsConstructor
class FeatureUiModule extends AbstractFeatureUiModule {
	
	/**
	 * Custom semantic highlighting
	 */
	def Class<? extends ISemanticHighlightingCalculator> bindSemanticHighlightingCalculator() {
		return SemanticHighlightingCalculator;
	}

	/**
	 * Custom highlighting styles
	 */
	def Class<? extends IHighlightingConfiguration> bindHighlightingConfiguration() {
		return HighlightingConfigurationCustom;
	}

	/**
	 * Custom syntax highlighting
	 */
	def Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindAbstractAntlrTokenToAttributeIdMapper() {
		return AntlrTokenToAttributeIdMapperCustom;
	}
	
    override IWorkspaceRoot bindIWorkspaceRootToInstance() {
        return ResourcesPlugin.getWorkspace().getRoot();
    }
	
}