package org.boomslang.dsl.mapping.services

import org.boomslang.dsl.mapping.mapping.BMapping
import org.boomslang.dsl.mapping.mapping.BWidgetMapping
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import org.boomslang.dsl.mapping.mapping.BMappingPackage

/**
 * This customizes imports to implicitly import 
 * elements from the referenced screen in the mapping language 
 */
class ImportedNamespaceAwareLocalScopeProviderCustom extends ImportedNamespaceAwareLocalScopeProvider {

	override List<ImportNormalizer> internalGetImportedNamespaceResolvers(EObject context, boolean ignoreCase) {
		val importedNamespaceResolvers = super.internalGetImportedNamespaceResolvers(context, ignoreCase)
		switch context {
			BMappingPackage:
				addWildcardImportFromSameNamespace(context, importedNamespaceResolvers, ignoreCase)
			BWidgetMapping:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
		}
		return importedNamespaceResolvers
	}

	def addWildcardImportFromSameNamespace(BMappingPackage bPackage, List<ImportNormalizer> importedNamespaceResolvers,
		boolean ignoreCase) {
		importedNamespaceResolvers.add(
			new ImportNormalizer(qualifiedNameProvider.getFullyQualifiedName(bPackage), true, ignoreCase))
	}

	/**
	 * find the top level BMapping element and add the fully qualified name of the referenced screen
	 * to the implicit imports 
	 */
	def void addNamespace(EObject dslObject, List<ImportNormalizer> importedNamespaceResolvers, boolean ignoreCase) {
		val bMapping = EcoreUtil2.getContainerOfType(dslObject, BMapping)
		val screen = bMapping.screen

		if (screen != null) {
			val qnameToAddImplicitly = qualifiedNameProvider.getFullyQualifiedName(screen)
			if (qnameToAddImplicitly != null) {
				importedNamespaceResolvers.add(new ImportNormalizer(qnameToAddImplicitly, true, ignoreCase))
			}
		}
	}

}
