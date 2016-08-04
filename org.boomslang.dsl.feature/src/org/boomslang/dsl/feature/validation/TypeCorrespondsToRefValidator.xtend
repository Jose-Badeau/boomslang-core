package org.boomslang.dsl.feature.validation

import com.google.inject.Inject
import org.boomslang.dsl.feature.feature.BWidgetWrapper
import org.boomslang.dsl.feature.services.WidgetTypeRefUtil
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

import static org.boomslang.dsl.feature.feature.FeaturePackage.Literals.*

class TypeCorrespondsToRefValidator extends AbstractDeclarativeValidator {
	
	override public void register(EValidatorRegistrar registrar) {
		// used as composed validator, nothing to register
	}
	
	@Inject extension WidgetTypeRefUtil widgetTypeRefUtil

	/**
	 * The requirements for the DSL included a redundant
	 * type specification after references, e.g.
	 * <pre>
	 * click on MyButton1 button
	 * </pre>
	 * where {@code button} is the name of the type of 
	 * {@code MyButton1} in lowercase.
	 * 
	 * This error code is used it the type name does not correspond
	 * to the actual type of the reference.
	 */
	public static val WRONG_TYPENAME = "WRONG_TYPENAME"

	@Check
	def checkTypeCorrespondsToRef(BWidgetWrapper it) {
		it.checkTypeCorrespondsToRef(BWIDGET_WRAPPER__WIDGET, BWIDGET_WRAPPER__WIDGET_TYPE)
	}

	/**
	 * The requirements for the DSL included a redundant
	 * type specification after references, e.g.
	 * <pre>
	 * click on MyButton1 button
	 * </pre>
	 * where {@code button} is the name of the type of 
	 * {@code MyButton1} in lower case.
	 * 
	 * This method is used to check that the type corresponds
	 * to the actual type of the reference.
	 * 
	 * @param dslObject - the EObject from the DSL with a reference to a widget and a String attribute that should 
	 * correspond to the widget's type
	 * 
	 * @param widgetRef - the EReference to the widget, is is expected to be of type NamingSupport (or a subclass)
	 * 
	 * @param widgetTypeNameRef - the type name, it is expected to be of type EString 
	 */
	def checkTypeCorrespondsToRef(EObject dslObject, EReference widgetERef, EAttribute widgetTypeNameERef) {
		val wireframeElementName = dslObject.getReferencedNameSupportName(widgetERef) 
		val wireframeElementTypeName = dslObject.getReferencedNameSupportTypeName(widgetERef)
		val typeNameInDsl = dslObject.getStringAttribute(widgetTypeNameERef)
		if (typeNameInDsl != wireframeElementTypeName) {
			error(
				'''�wireframeElementName� is a '�wireframeElementTypeName�', but the text says it is a '�typeNameInDsl.
					nullToEmpty�'��''', widgetTypeNameERef, WRONG_TYPENAME, wireframeElementTypeName)
		}
	}
}