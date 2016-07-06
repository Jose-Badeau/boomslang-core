package org.boomslang.dsl.mapping.ui.highlighting

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.CrossReference
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.nodemodel.ICompositeNode
import org.eclipse.xtext.nodemodel.ILeafNode
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.resource.XtextResource

import static org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration.*
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.util.CancelIndicator
import org.boomslang.dsl.mapping.services.MappingGrammarAccess

class SemanticHighlightingCalculator implements ISemanticHighlightingCalculator {

	@Inject extension MappingGrammarAccess


	/**
     * recursively process tree
     */
	def protected void highlightSemanticModel(INode node, IHighlightedPositionAcceptor acceptor) {

		// walk the tree
		if (node instanceof ICompositeNode) {
			switch (it : node.grammarElement) {
				RuleCall case rule.name == qualifiedNameRule.name: {
					acceptor.addPosition(node.offset, node.length, DEFAULT_ID)
				}
				CrossReference: {
					acceptor.addPosition(node.offset, node.length, DEFAULT_ID)
				}
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
		// val grammarElement = node.grammarElement
		//      if (grammarElement instanceof Keyword) {
		//          val ParserRule parserRule = EcoreUtil2::getContainerOfType(
		//                  grammarElement, typeof(ParserRule));
		//          if ("XID".equals(parserRule.getName())) {
		//              applyDefaultStyle(node, acceptor);
		//          }
		//      }
		//        if (varIgnorePrefix != null) {
		//            val int start = node.getOffset()
		//                    + node.getText().indexOf(varIgnorePrefix);
		//            acceptor.addPosition(start, varIgnorePrefix.length(),
		//                    HighlightingConfigurationCustom::TODO_STYLE);
		//        }
	}
	
	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator cancelIndicator) {
		if (resource == null || resource.getParseResult() == null || (resource.contents.size() == 0)) {
			return
		}
		val EObject rootObject = resource.contents.get(0)
		highlightSemanticModel(NodeModelUtils::findActualNodeFor(rootObject), acceptor)
	}

}
