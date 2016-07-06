package org.boomslang.dsl.feature.validation

import org.boomslang.core.CorePackage
import org.boomslang.dsl.feature.feature.BFeature
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class FilenameValidator extends AbstractDeclarativeValidator {

	public static val String MODEL_NAME_NOT_EQUAL_TO_FILE_NAME = "MODEL_NAME_NOT_EQUAL_TO_FILE_NAME"
	
	override public void register(EValidatorRegistrar registrar) {
		// used as composed validator, nothing to register
	}

	@Check
	def void checkBFeatureElementNameEqualsFileName(BFeature it) {
		val filePath = eResource.URI.path
		val fileName = filePath.substring(filePath.lastIndexOf("/") + 1, filePath.lastIndexOf("."))
		if (!fileName.equals(name)) {
			warning(
				"The Feature should have the same name as the file that contains it.",
				CorePackage.Literals::BNAMED_MODEL_ELEMENT__NAME,
				MODEL_NAME_NOT_EQUAL_TO_FILE_NAME
			)
		}
	}

}
