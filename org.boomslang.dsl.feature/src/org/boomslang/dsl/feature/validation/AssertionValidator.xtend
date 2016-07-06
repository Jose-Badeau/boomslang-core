package org.boomslang.dsl.feature.validation

import org.boomslang.dsl.feature.feature.BBooleanPropertyAssertion
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar
import org.boomslang.dsl.feature.services.BWidgetUtil
import com.google.inject.Inject
import org.boomslang.dsl.feature.feature.FeaturePackage

/**
 * Check methods for BAssertions
 */
class AssertionValidator extends AbstractFeatureValidator {
	
	public static val String BOOLEAN_PROPERTY_NAME_INVALID = "BOOLEAN_PROPERTY_NAME_INVALID"
	
	@Inject extension BWidgetUtil

	override public void register(EValidatorRegistrar registrar) {
		// used as composed validator, nothing to register
	}
	
	@Check
	def checkBBooleanPropertyAssertion(BBooleanPropertyAssertion bBooleanPropertyAssertion) {
		if (bBooleanPropertyAssertion == null) {
			return null
		}
		val actualName = bBooleanPropertyAssertion.booleanPropertyName
		val widget = bBooleanPropertyAssertion.assertionWidgetWrapper.widget
		val validNames =  widget.namesOfBooleanAttributes
		if (!validNames.contains(actualName)) {
		   error(
				'''«actualName» is not a boolean property of the «widget.name» «widget.type», allowed: «validNames.join(", ")»''',
				bBooleanPropertyAssertion, FeaturePackage.Literals.BBOOLEAN_PROPERTY_ASSERTION__BOOLEAN_PROPERTY_NAME, BOOLEAN_PROPERTY_NAME_INVALID,
				validNames)
		}
	} 
	
}