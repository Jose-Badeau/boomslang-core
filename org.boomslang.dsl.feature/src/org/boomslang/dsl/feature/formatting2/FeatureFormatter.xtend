/*
 * generated by Xtext 2.10.0
 */
package org.boomslang.dsl.feature.formatting2

import org.boomslang.core.BImport
import org.boomslang.dsl.feature.feature.BFeature
import org.boomslang.dsl.feature.feature.BFeaturePackage
import org.boomslang.dsl.feature.feature.BScenario
import org.boomslang.dsl.feature.services.FeatureGrammarAccess
import com.google.inject.Inject
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument

class FeatureFormatter extends AbstractFormatter2 {
	
	@Inject extension FeatureGrammarAccess

	def dispatch void format(BFeaturePackage bFeaturePackage, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		
		for (BImport bImports : bFeaturePackage.getBImports()) {
			bImports.format;
		}
		for (BFeature bFeature : bFeaturePackage.getBFeature()) {
			bFeature.format;
		}
	}

	def dispatch void format(BFeature bFeature, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		bFeature.getBackground.format;
		for (BScenario scenarios : bFeature.getScenarios()) {
			scenarios.format;
		}
	}
	
	// TODO: implement for BScenario, BListSelectNamesCommand, BListSelectValuesCommand, BListSelectIndicesCommand, BDoubleClickCommand, BTableCommand, BTypeCommand, BTabPaneSelectTabCommand, BTreeCommand, BContextMenuCommand, BAccordionCommand, BScreenshotAssertion, BWidgetWrapperList, BListSelectionByNamesAssertion, BListSelectionByValuesAssertion, BListSelectionByIndicesAssertion, BListContainsByNamesAssertion, BListContainsByIndicesAssertion, BListContainsByValuesAssertion, BTableRowColAssertion, BTableHeaderAssertion, BTreeAssertion, NodeQName, BTabAssertion, BBooleanPropertyAssertion, BPropertyEqualsAssertion, BTextEqualsAssertion, BTextContainsAsssertion
}
