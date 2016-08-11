package org.boomslang.dsl.feature.validation

import com.google.inject.Inject
import org.boomslang.dsl.feature.feature.BBooleanAssertionAction
import org.boomslang.dsl.feature.feature.FeaturePackage
import org.boomslang.dsl.feature.services.BWidgetUtil
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
import org.boomslang.dsl.feature.services.WidgetTypeRefUtil

/**
 * Check methods for BAssertions
 */
class AssertionValidator extends AbstractFeatureValidator {
	
	public static val String BOOLEAN_PROPERTY_NAME_INVALID = "BOOLEAN_PROPERTY_NAME_INVALID"
	
	@Inject extension BWidgetUtil
	
	@Inject extension WidgetTypeRefUtil
		

	override public void register(EValidatorRegistrar registrar) {
		// used as composed validator, nothing to register
	}
	
	@Check
	def checkBBooleanPropertyAssertion(BBooleanAssertionAction bBooleanAssertionAction) {
		if (bBooleanAssertionAction == null) {
			return null
		}
		val actualName = bBooleanAssertionAction.booleanPropertyName
		val widget = bBooleanAssertionAction.widgetBeforeOffset
		val validNames =  widget.namesOfBooleanAttributes
		if (!validNames.contains(actualName)) {
		   error(
				'''«actualName» is not a boolean property of the «widget.name»«widget.type»» , allowed:«validNames.join(", ")» ''',
				bBooleanAssertionAction, FeaturePackage.Literals.BBOOLEAN_ASSERTION_ACTION__BOOLEAN_PROPERTY_NAME, BOOLEAN_PROPERTY_NAME_INVALID,
				validNames)
		}
	} 
	
}