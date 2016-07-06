package org.boomslang.core.validation

import org.boomslang.core.BPackage
import org.boomslang.core.CorePackage
import org.boomslang.core.services.JavaProjectFolderUtil
import com.google.inject.Inject
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class PackageFolderStructureValidator extends AbstractDeclarativeValidator {

	public static val String PACKAGE_FOLDER_STRUCTURE = "PACKAGE_FOLDER_STRUCTURE"

	override public void register(EValidatorRegistrar registrar) {
		// used as composed validator, nothing to register
	}

	@Inject extension JavaProjectFolderUtil

	/** 
	 * Method that generates a warning validation issue  if a package declaration 
	 * does not conform to the folder structure it is located in.<p/>
	 * 
	 * This check is only applied if the URI of the {@code pack} is a 'platform:/resource' URI.
	 */
	@Check
	def void checkPackage(BPackage pack) {
		val currentFullPath = pack.eResource.IResource.fullPath
		
		val srcPaths = pack.getSrcPaths
		if (srcPaths.nullOrEmpty) {
			return
		}

		// check which src path this model element is in
		for (srcPath : srcPaths) {

			if (currentFullPath.toString.startsWith(srcPath.toString)) {
				
				val suggestedPath = currentFullPath.removeFirstSegments(srcPath.segmentCount).removeLastSegments(1).toString
				val suggestedPackageName = suggestedPath.replaceAll("/", ".")
				val suggestedFullPathString = srcPath + "/" + pack.name.replaceAll('''\.''',"/") + "/" + pack.eResource.URI.lastSegment

				// Check if package name reflects the folder it is located in.
				if (pack.getName != suggestedPackageName) {
					warning(
						'''
							A package should correspond to folder structure where the file is in.
							Either the file should be in directory '«suggestedPath»',
							or the package should be named '«suggestedPackageName»'.
						''',
						CorePackage.Literals::BNAMED_MODEL_ELEMENT__NAME,
						PACKAGE_FOLDER_STRUCTURE,
						suggestedPackageName,
						currentFullPath.toString,
						suggestedFullPathString
					)
					return
				}
			}
		}
	}
}
