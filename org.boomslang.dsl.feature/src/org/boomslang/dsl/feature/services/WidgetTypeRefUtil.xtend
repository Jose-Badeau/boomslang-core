package org.boomslang.dsl.feature.services

import org.boomslang.dsl.feature.feature.BCodeStatement
import org.boomslang.dsl.feature.feature.BScenario
import org.boomslang.dsl.feature.feature.BToFrameSwitch
import org.boomslang.dsl.feature.feature.BToScreenSwitch
import com.wireframesketcher.model.ModelPackage
import com.wireframesketcher.model.NameSupport
import com.wireframesketcher.model.WidgetContainer
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EcorePackage

import static extension org.eclipse.xtext.EcoreUtil2.*
import com.wireframesketcher.model.Master

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
	def WidgetContainer getWidgetContainerOfNearestContext(EObject dslObject) {
		dslObject.getContextInfoOfNearestContext.widgetContainer
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
					BToFrameSwitch: return new ContextInfo(candidate.screen, candidate.frameID)
					BToScreenSwitch: return new ContextInfo(candidate.screen, null)
				}
				i = i - 1
			}
		}
		//TODO temporary solution. Only works for Screens that only have reference to a reused component
		val screen = bScenario.BToScreenSwitch?.screen
		val widget = screen.widgets.findFirst[it instanceof Master]
		if(widget!=null){
			return new ContextInfo((widget as Master).screen,null)
		}
		// no screen context found, use screen of BScenario
		return new ContextInfo(bScenario.BToScreenSwitch?.screen, null)
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
	// null if not in a frame
	String frameName
}