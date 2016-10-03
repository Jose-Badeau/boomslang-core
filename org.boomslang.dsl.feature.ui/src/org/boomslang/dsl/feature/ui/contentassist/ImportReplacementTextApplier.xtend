package org.boomslang.dsl.feature.ui.contentassist

import org.boomslang.dsl.feature.feature.BFeaturePackage
import com.google.inject.Inject
import org.eclipse.jface.text.BadLocationException
import org.eclipse.jface.text.IDocument
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ui.editor.contentassist.ConfigurableCompletionProposal
import org.eclipse.xtext.ui.editor.contentassist.ReplacementTextApplier
import org.eclipse.xtext.ui.editor.model.IXtextDocument
import org.eclipse.xtext.util.concurrent.IUnitOfWork

class ImportReplacementTextApplier extends ReplacementTextApplier {

    val public static ADDITIONAL_DATA_QNAME = "QNAME"

    @Inject IQualifiedNameConverter qualifiedNameConverter

    override apply(IDocument document, ConfigurableCompletionProposal proposal) throws BadLocationException {
        val proposalAux = proposal;
        (document as IXtextDocument).modify(new IUnitOfWork.Void<XtextResource>() {
            override process(XtextResource resource) {
                val qName = qualifiedNameImportStatement(proposalAux)
                val bPackage = resource.getContents().get(0) as BFeaturePackage
		        val useQualifiedName = nameAlreadyUsed(bPackage, proposal, qName)
		        
		        // apply the proposal
		        applyProposal(document, proposal, useQualifiedName)
                
                // add import statements if applicable
                if (qName != null && !useQualifiedName) {
                    if (bPackage.BImports.filter[importedNamespace.startsWith(qName)].size < 1) {
                        // Get the last import statement if non import exists the package declaration is taken
                        val node = if(bPackage.BImports.size>0){
                            NodeModelUtils.getNode(bPackage.BImports.last)
                        }else{
                            //Requires the feature file to have a valid package declaration in the first line
                            NodeModelUtils.getNode(bPackage)?.children?.get(1) 
                        }
                        // Append the new import statement
                        val newText = node.text + "\nimport " + qName
                        // Set the cursor Position to the end of the line. Computed by adding the new import statement to the cursor position before.
                        proposal.cursorPosition = (proposal.cursorPosition + qName.length + 8)
                        // Add the new import statement by replacing the last with the former last import stated enhanced by the new import statement.
                        document.replace(node.totalOffset, node.text.length, newText)
                        
                    }
                }
            }
        })
    }
    
    /**
     * Returns true if the the simple name is already imported for another qualified name
     */
    def boolean nameAlreadyUsed(BFeaturePackage bPackage, ConfigurableCompletionProposal proposal, String qName) {
    	val simpleName = qName.lastSegment
        bPackage.BImports.exists[
        	importedNamespace.lastSegment == simpleName && !(importedNamespace == qName)
        ]
	}
	
	def lastSegment(String qualifiedName) {
		qualifiedName.split("\\.").last
	}
    
    /** 
     * Custom variation of the super method applyProposal with an additional parameter 
     */
    def applyProposal(IDocument document, ConfigurableCompletionProposal proposal, boolean useQualifiedName) throws BadLocationException {
        val replacementString = if (useQualifiedName) {
           	getActualReplacementString(proposal)
        } else {
            proposal.replacementString
        }
		proposal.setCursorPosition(replacementString.length());
		document.replace(proposal.getReplacementOffset(), proposal.getReplacementLength(), replacementString);
	}    
    

    /**
     * Computes the actual replacement string only in case that the qualified name must be used
     */
    override getActualReplacementString(ConfigurableCompletionProposal proposal) {    	
        val qname = (proposal.getAdditionalData(ADDITIONAL_DATA_QNAME) as QualifiedName)
        val simpleName = qualifiedNameConverter.toString(qname)
        val actualString = simpleName + " " + proposal.additionalProposalInfo + " "
        return actualString        
    }

    /**
     * Computes the qualified name that should be stated in the import statement. Usually it is the name
     * of the widgets container. 
     * In case it is a widget container itself (e.g. screen) the name of widget container itself is stated
     * If a tab from a tabbedpane is referenced the import will be fullqualified screen name + tabbed pane name + ".*"
     */
    def private qualifiedNameImportStatement(ConfigurableCompletionProposal proposal) {
        var qNameInternal = (proposal.getAdditionalData(ADDITIONAL_DATA_QNAME) as QualifiedName)
        //If proposed element is a widget container such as screen, don't skip the last segment
        //Otherwise the last segment contains the name of the widget and can be skipped because only the
        //container name (screen name) is important
        if(!("screen".equals(proposal.additionalProposalInfo.trim)||"::".equals(proposal.additionalProposalInfo))){
            qNameInternal =qNameInternal.skipLast(1)
        }
        //Since a tab is a widget within another widget (tabbed pane) all parts of the tabbed pane need to be 
        //imported. That is done by adding an additional * segment to the tabbed pane widget name.
        if ("tab".equals(proposal.additionalProposalInfo)) {
            qNameInternal = qNameInternal.append("*")
        }
        qualifiedNameConverter.toString(qNameInternal)
    }

}
