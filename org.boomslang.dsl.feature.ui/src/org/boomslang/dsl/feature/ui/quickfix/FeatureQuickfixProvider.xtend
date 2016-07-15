/*
 * generated by Xtext 2.10.0
 */
package org.boomslang.dsl.feature.ui.quickfix

import org.boomslang.core.validation.PackageFolderStructureValidator
import org.boomslang.dsl.feature.feature.BClickCommand
import org.boomslang.dsl.feature.feature.BFeature
import org.boomslang.dsl.feature.feature.BTypeCommand
import org.boomslang.dsl.feature.feature.BWidgetWrapper
import org.boomslang.dsl.feature.validation.AssertionValidator
import org.boomslang.dsl.feature.validation.FilenameValidator
import org.boomslang.dsl.feature.validation.TypeCorrespondsToRefValidator
import org.boomslang.ui.quickfix.PackageFolderStructureQuickfix
import com.google.inject.Inject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.model.edit.IModificationContext
import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider
import org.eclipse.xtext.ui.editor.quickfix.Fix
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue
import org.boomslang.dsl.feature.feature.BBooleanPropertyAssertion
import org.boomslang.dsl.feature.validation.FeatureValidator

import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.IEObjectDescription
import org.boomslang.dsl.mapping.mapping.MappingPackage
import org.boomslang.dsl.mapping.mapping.BMappingPackage
import com.wireframesketcher.model.Screen
import org.boomslang.dsl.mapping.mapping.MappingFactory
import org.boomslang.dsl.mapping.mapping.BWidgetMapping
import org.boomslang.dsl.feature.feature.BScenario 

/**
 * Custom quickfixes.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#quickfixes
 */
class FeatureQuickfixProvider extends DefaultQuickfixProvider {

	@Inject PackageFolderStructureQuickfix packageFolderStructureQuickfix
	
	@Inject ResourceDescriptionsProvider resourceDescriptionsProvider;

    @Inject IContainer.Manager containerManager;

	@Fix(TypeCorrespondsToRefValidator::WRONG_TYPENAME)
	def capitalizeName(Issue issue, IssueResolutionAcceptor acceptor) {
		val expected = issue.data.head
		if (expected.nullOrEmpty) {
			return
		}
		val msg = "Change to '" + expected + "'"
		acceptor.accept(issue, msg, msg, null) [ EObject element, IModificationContext context |
			switch (element) {
				BClickCommand: element.clickSupportType = expected
				BTypeCommand: element.textInputSupportType = expected
				BWidgetWrapper: element.widgetType = expected
			}
		]
	}

	/**
	 * Renames the package declaration so it matches the name of the project it is in,
	 * or moves the file so that the directory structure matches the package name. 
	 */
	@Fix(PackageFolderStructureValidator::PACKAGE_FOLDER_STRUCTURE)
	def public void renamePackage(Issue issue, IssueResolutionAcceptor acceptor) {
		packageFolderStructureQuickfix.alignPackageAndFolder(issue, acceptor)
	}

	/**
     * This quick fix either renames the model element to match the file name,
     * or renames the file name to match the model name
	 */
	@Fix(FilenameValidator::MODEL_NAME_NOT_EQUAL_TO_FILE_NAME)
	def public void alignNaming(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue, "Rename feature", "Rename the feature to match the file name.", "package_obj.gif",
			[ EObject element, IModificationContext context |
				val filePath = element.eResource.URI.path
				val nameInPath = filePath.substring(filePath.lastIndexOf("/") + 1, filePath.lastIndexOf("."))
				(element as BFeature).setName(nameInPath)
			])

		acceptor.accept(issue, "Rename file", "Renames the file to match the feature name.", "correction_move.gif",
			[ EObject element, IModificationContext context |
				val workspace = ResourcesPlugin::getWorkspace()
				val resource = workspace.root.findMember(element.eResource.URI.toPlatformString(true))
				val fileExtension = resource.fullPath.fileExtension
				val filePath = resource.fullPath.removeLastSegments(1).append(
					(element as BFeature).name + "." + fileExtension)
				resource.move(filePath, true, null)
			])
	}

	/**
	 * changes boolean property names to valid names 
	 */
	@Fix(AssertionValidator::BOOLEAN_PROPERTY_NAME_INVALID)
	def public void changeToValidBooleanPropertyname(Issue issue, IssueResolutionAcceptor acceptor) {
		val allowedNames = issue.data
		if (allowedNames.nullOrEmpty) {
			return
		}
		for (name : allowedNames) {
			val suggestion = "Rename to " + name
			acceptor.accept(issue, suggestion, suggestion, null,
				[ EObject element, IModificationContext context |
					switch (element) {
						BBooleanPropertyAssertion: {
							element.booleanPropertyName = name
						}
					}
				])
		}
	}
	
	@Fix(FeatureValidator::SCENARIO_NAME_VALID)
	def public void cleanScenarioName(Issue issue, IssueResolutionAcceptor acceptor){
	    acceptor.accept(issue,"Clean scenario name","Remove all characters that are not literal, number or whitespace",null, [ element, context | 
	        var newName=""
	        switch (element){
	           BScenario:{
                      var oldName=element.name
                      for(var i=0;i<element.name.length;i++){
                          val currentChar=element.name.charAt(i)
                          if(Character.isLetter(currentChar)||Character.isDigit(currentChar)||Character.isWhitespace(currentChar)||currentChar.compareTo('"')==0){
                              newName=newName + currentChar
                          }
                      }
                      //Replacement done in text not in model. Added 2 for the leading and tailing "
                      context.getXtextDocument().replace(issue.offset,(oldName.length+2),newName)    
               }  
	        }
	          
	    ])
	}
	
	/**
	 * Create a mapping entry for the not mapped widget
	 */
	 @Fix(FeatureValidator::NO_MAPPING_FOR_WIDGET)
	 def public void createMappingEntryUnmappedWidget(Issue issue, IssueResolutionAcceptor acceptor){
	     println(issue)
	    val splitted = issue.data.get(0).split(";")
        if (splitted.length < 2) {
            return
        }
        acceptor.accept(issue, "Create missing mapping for " + splitted.get(0),
            "Create missing mapping for " + splitted.get(0) + " " + splitted.get(1), null, [ element, context |
                //val mapping = element.getContainerOfType((typeof(BMapping)))
                    println(element)
                    val wrapper=element as BWidgetWrapper
                    val index = resourceDescriptionsProvider.getResourceDescriptions(wrapper.eResource());
                    val resourceDescription = index.getResourceDescription(wrapper.eResource().getURI());
                    for (IContainer visibleContainer : containerManager.getVisibleContainers(resourceDescription, index)) {
                        for (IEObjectDescription od : visibleContainer.getExportedObjectsByType(
                            MappingPackage.Literals.BMAPPING_PACKAGE)) {
                            val bMappingPackage = element.eResource().getResourceSet().getEObject(od.getEObjectURI(), true) as BMappingPackage;
                            println(bMappingPackage.name)
                            if(bMappingPackage.BMapping.screen.equals(wrapper.widget.container as Screen)){
                                println("searchingfor: "+wrapper.widget)
                                for(BWidgetMapping w : bMappingPackage.BMapping.BWidgetMapping){
                                    println(w.widget.name)
                                }
                                if(bMappingPackage.BMapping.BWidgetMapping.findFirst[it.widget.equals(wrapper.widget)]==null){
                                    println("geht doch")
                                      val locatedWidget = bMappingPackage.BMapping?.screen?.widgets.filter [
                                            splitted.get(0).equals(it.name) && it.class.name.contains(splitted.get(1))
                                        ]
                                    bMappingPackage.BMapping.BWidgetMapping.add(bMappingPackage.BMapping.BWidgetMapping.size,
                                    MappingFactory::eINSTANCE.createBWidgetMapping => [
                                        widget = locatedWidget.get(0)
                                        locator = MappingFactory::eINSTANCE.createMStringLiteral => [
                                            value = "replaceWithTheCorrextId"
                                        ]
                                    ])
                                }
                                
                                }
                                
                                }
                                
                                }
//                val locatedWidget = mapping?.screen?.widgets.filter [
//                    splitted.get(0).equals(it.name) && it.class.name.contains(splitted.get(1))
//                ]
//                if (locatedWidget.length == 1) {
//                    mapping.BWidgetMapping.add(mapping.BWidgetMapping.size,
//                        MappingFactory::eINSTANCE.createBWidgetMapping => [
//                            widget = locatedWidget.get(0)
//                            locator = MappingFactory::eINSTANCE.createMStringLiteral => [
//                                value = "replaceWithTheCorrextId"
//                            ]
//                        ])
//                }
            ])
	 }
}