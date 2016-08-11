package org.boomslang.dsl.feature.services

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EcorePackage

/**
 * Util methods for validation and content assist that depends on widgets that are referenced in the DSL
 */
class BWidgetUtil {

	/**
	 * return a list of names of attributes of type EBoolean of the given EObject
	 */
	def List<String> namesOfBooleanAttributes(EObject model) {
		val result = <String>newArrayList
		for (att : model.eClass.getEAllAttributes) {
			if (att.getEAttributeType == EcorePackage$Literals.EBOOLEAN) {
				result += att.name
			}
		}
		return result
	}
	
	/**
	 * Returns all property names that are not type boolean 
	 */
	def List<String> namesOfProperties(EObject model){
		val result = <String>newArrayList
		for (att : model.eClass.getEAllAttributes) {
			if (att.getEAttributeType != EcorePackage$Literals.EBOOLEAN) {
				result += att.name
			}
		}
		return result
	}

}
