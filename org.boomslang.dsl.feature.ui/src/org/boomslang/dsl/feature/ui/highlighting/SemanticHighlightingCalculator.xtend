package org.boomslang.dsl.feature.ui.highlighting

import org.boomslang.dsl.feature.services.FeatureGrammarAccess
import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.nodemodel.ICompositeNode
import org.eclipse.xtext.nodemodel.ILeafNode
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.resource.XtextResource

import static org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration.*
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor

class SemanticHighlightingCalculator implements ISemanticHighlightingCalculator {

	@Inject extension FeatureGrammarAccess

	/**
     * recursively process tree
     */
	def protected void highlightSemanticModel(INode node, IHighlightedPositionAcceptor acceptor) {

		//        // Process cross references
		//        // TODO catches all cross references, not only specific types of cross references
		//        if (node.grammarElement instanceof CrossReference) {
		//            acceptor.addPosition(node.getOffset(), node.getLength(),
		//                 HighlightingConfigurationCustom::CROSS_REF)
		//             
		//        } 
		// walk the tree
		if (node instanceof ICompositeNode) {
			switch (it : node.grammarElement) {
//				RuleCall case rule.name == textToEolRule.name: {
//					acceptor.addPosition(node.offset, node.length, DEFAULT_ID)
//				}
				RuleCall case rule.name == idOrKeywordRule.name: {
					acceptor.addPosition(node.offset, node.length, DEFAULT_ID)
				}
				RuleCall case rule.name == qualifiedNameRule.name: {
					acceptor.addPosition(node.offset, node.length, DEFAULT_ID)
				}
				// @param should be highlighted like a keyword
				RuleCall case rule.name == atParamRule.name: {
					acceptor.addPosition(node.offset, node.length, HighlightingConfigurationCustom::ANNOTATION_STYLE)
				}
				RuleCall case rule.name == atDataProviderRule.name: {
					acceptor.addPosition(node.offset, node.length, HighlightingConfigurationCustom::ANNOTATION_STYLE)
				}
				RuleCall case rule.name == atDependsOnRule.name: {
					acceptor.addPosition(node.offset, node.length, HighlightingConfigurationCustom::ANNOTATION_STYLE)
				}
				RuleCall case rule.name == atTagScreenRule.name: {
					acceptor.addPosition(node.offset, node.length, HighlightingConfigurationCustom::ANNOTATION_STYLE)
				}
				RuleCall case rule.name == tagModeRule.name: {
					acceptor.addPosition(node.offset, node.length, HighlightingConfigurationCustom::ANNOTATION_STYLE)
				}
			//				CrossReference : {
			//					val lastUnderscoreIndex = node.text.lastIndexOf('_')
			//					if (lastUnderscoreIndex > 0) {
			//						acceptor.addPosition(node.offset + lastUnderscoreIndex - 1, 1, HighlightingConfigurationCustom.ANNOTATION_STYLE)
			//					}
			//				}
			}
			for (INode child : (node as ICompositeNode).getChildren()) {
				highlightSemanticModel(child, acceptor);
			}
		} else if (node instanceof ILeafNode) {
			highlightLeafNode(node as ILeafNode, acceptor);
		}
	}

	def protected void highlightLeafNode(ILeafNode node, IHighlightedPositionAcceptor acceptor) {

		/**
         * in case keywords are used for other grammar rules like XID, highlight them in default style
         * this is not yet needed
         */

	//			if (node.grammarElement instanceof Keyword) {
	//		          val ParserRule parserRule = EcoreUtil2::getContainerOfType(
	//		                  node.grammarElement, typeof(ParserRule));
	//          if ("XID".equals(parserRule.getName())) {
	//              applyDefaultStyle(node, acceptor);
	//          }
	//        if (varIgnorePrefix != null) {
	//            val int start = node.getOffset()
	//                    + node.getText().indexOf(varIgnorePrefix);
	//            acceptor.addPosition(start, varIgnorePrefix.length(),
	//                    HighlightingConfigurationCustom::TODO_STYLE);
	//        }
	}
	
	override provideHighlightingFor(XtextResource resource, org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor acceptor, CancelIndicator cancelIndicator) {
		if (resource == null || resource.getParseResult() == null || (resource.contents.size() == 0)) {
			return
		}
		val EObject rootObject = resource.contents.get(0)
		highlightSemanticModel(NodeModelUtils::findActualNodeFor(rootObject), acceptor)
	}

}
