package org.boomslang.dsl.feature.services

import com.wireframesketcher.model.Master
import com.wireframesketcher.model.ModelPackage
import com.wireframesketcher.model.NameSupport
import com.wireframesketcher.model.WidgetContainer
import org.boomslang.dsl.feature.feature.BCodeStatement
import org.boomslang.dsl.feature.feature.BCommandComponent
import org.boomslang.dsl.feature.feature.BScenario
import org.boomslang.dsl.feature.feature.BToScreenSwitch
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.xtend.lib.annotations.Data

import static extension org.eclipse.xtext.EcoreUtil2.*
import com.wireframesketcher.model.SelectionSupport
import com.wireframesketcher.model.ClickSupport
import com.wireframesketcher.model.DoubleClickSupport
import com.wireframesketcher.model.TextInputSupport
import com.wireframesketcher.model.BooleanSelectionSupport
import org.boomslang.dsl.feature.feature.BAssertionComponent
import com.wireframesketcher.model.TabbedPane

class WidgetTypeRefUtil {

	/**
	 * Generic method to return the NameSupport wireframe model element that is referenced by
	 * a given {@code dslObject} (using a given {@code widgetRef})
	 */
	def getReferencedNameSupport(EObject dslObject, EReference nameSupportRef) {
		if (dslObject == null || nameSupportRef == null || !(nameSupportRef.getEReferenceType ==
			ModelPackage.Literals.NAME_SUPPORT ||
			nameSupportRef.getEReferenceType.getEAllSuperTypes.contains(ModelPackage.Literals.NAME_SUPPORT)) ||
			!dslObject.eClass.getEAllReferences.contains(nameSupportRef)) {

			// TODO log error, model is not as expected
			return null
		}
		val nameSupport = dslObject.eGet(nameSupportRef, true) as NameSupport
		return nameSupport
	}

	/**
	 * @return the name of the NameSupport the given dslObject points to, assuming the
	 * given {@code nameSupportRef} is a reference to a NameSupport or {@code null}
	 */
	def getReferencedNameSupportName(EObject dslObject, EReference nameSupportRef) {
		val nameSupport = getReferencedNameSupport(dslObject, nameSupportRef)
		return nameSupport?.name
	}

	/**
	 * @return the type name of the NameSupport the given dslObject points to, assuming the
	 * given {@code nameSupportRef} is a reference to a NameSupport or {@code null}
	 */
	def getReferencedNameSupportTypeName(EObject dslObject, EReference nameSupportRef) {
		val nameSupport = getReferencedNameSupport(dslObject, nameSupportRef)
		return nameSupport?.eClass?.name?.toLowerCase
	}

	/**
	 * Generic method to return the value of a String attribute when given
	 * a {@code dslObject} and an EAttribute.
	 */
	def getStringAttribute(EObject dslObject, EAttribute stringAttribute) {
		if (dslObject == null || stringAttribute == null ||
			!dslObject.eClass.getEAllAttributes.contains(stringAttribute) ||
			stringAttribute.getEType != EcorePackage.Literals.ESTRING) {

			// TODO log error
			return null
		}
		return dslObject.eGet(stringAttribute) as String
	}

	/**
	 * Note: A Widget is from the wireframe model, a BWidgetContainer is from the Feature DSL that references
	 * a Widget from the wireframe model.
	 * 
	 * @param dslObject - an element of the DSL which is contained (directly or indirectly) in BCodeStatement or a
	 * BScenario
	 * 
	 * @return 1) if dslObject is contained in a BCodeStatement and there is a preceding BCodeStatement with a screen reference, said screen
	 * 2) otherwise the screen of the BScenario
	 */
	def  getWidgetContainerOfNearestContext(EObject dslObject) {
 		dslObject.getContextInfoOfNearestContext.widgetContainer?.allReferencedScreens
		
	}
	
	/**
	 * Since a screen can refer to multiple different component screens. This method adds all screens to
	 * the return set that are used by the referenced screen
	 */
	def getAllReferencedScreens(WidgetContainer container){
		val retList= newArrayList(container);
		container.widgets.filter[it instanceof Master].forEach[retList.add((it as Master).screen)]
		return retList
	}
	
	def ContextInfo getContextInfoOfNearestContext(EObject dslObject) {
		
		if (dslObject == null) {
			return null
		}

		val bScenario = dslObject.getContainerOfType(BScenario)
		if (bScenario == null) {
			return null
		}
		val codeStatement = dslObject.getContainerOfType(BCodeStatement)
		
		if(codeStatement instanceof BToScreenSwitch){
			return new ContextInfo(bScenario.BToScreenSwitch?.determineScreen, null)
		}
        
		if (codeStatement != null) {

			// take the latest switchToScreen or switchToFrame statement
			// or 
			val index = bScenario.codeStatements.indexOf(codeStatement)
			if (index == -1) {

				// log error
				return null
			}
			var i = index - 1
			while (i > 0) {
				val candidate = bScenario.codeStatements.get(i)
				switch (candidate) {
					BToScreenSwitch: return new ContextInfo(candidate.screen, null)
				}
				i = i - 1
			}
		}
		// no screen context found, use screen of BScenario
		return new ContextInfo(bScenario.BToScreenSwitch?.screen, null)
	}
	
	def getWidgetBeforeOffset(EObject element){
		if(element instanceof BCommandComponent){
			return element.widget.widget
		}
		if(element.getContainerOfType(BCommandComponent)!=null){
			return	element.getContainerOfType(BCommandComponent).widget.widget
		}else{
			return	element.getContainerOfType(BAssertionComponent).widget.widget
		}
		
	}
	
	def isContextOfSelectableWidget(EObject model){
		model.widgetBeforeOffset instanceof SelectionSupport 
			&& !(model.widgetBeforeOffset instanceof TabbedPane) // uses 'I select the' instead of 'I select'
	}
	def isContextOfClickableWidget(EObject model){
		model.widgetBeforeOffset instanceof ClickSupport
	}
	def isContextOfDoubleClickableWidget(EObject model){
		model.widgetBeforeOffset instanceof DoubleClickSupport
	}
	def isContextOfTypeableWidget(EObject model){
		model.widgetBeforeOffset instanceof TextInputSupport
	}
	def isContextOfCCheckableWidget(EObject model){
		model.widgetBeforeOffset instanceof BooleanSelectionSupport
	}
	
	def determineScreen(BToScreenSwitch it) {
		if (componentPartScreen != null) {
			return componentPartScreen
		} else {
			return screen
		}
	}

}


/** 
 * Holds information about the context of a code statement:
 * 1) in which screen the code statement is
 * 2) in which frame said screen is (if applicable) 
 */
@Data
class ContextInfo {
	WidgetContainer widgetContainer
	// null if not in a frame  - from svn
	String frameName
}