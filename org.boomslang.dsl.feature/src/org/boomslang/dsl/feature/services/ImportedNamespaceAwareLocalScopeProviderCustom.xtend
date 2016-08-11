package org.boomslang.dsl.feature.services

import com.google.inject.Inject
import java.util.List
import org.boomslang.core.BPackage
import org.boomslang.dsl.feature.feature.BAssertionComponentActionParameter
import org.boomslang.dsl.feature.feature.BComboWrapper
import org.boomslang.dsl.feature.feature.BCommandComponentActionParameter
import org.boomslang.dsl.feature.feature.BTabItemWrapper
import org.boomslang.dsl.feature.feature.BTableWrapper
import org.boomslang.dsl.feature.feature.BTreeWrapper
import org.boomslang.dsl.feature.feature.BWidgetWrapper
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider

/**
 * This customizes imports so that  
 * elements from a screen given in the parent
 * are implicitly imported 
 */
class ImportedNamespaceAwareLocalScopeProviderCustom extends ImportedNamespaceAwareLocalScopeProvider {

	@Inject extension WidgetTypeRefUtil

	/**
	 * Import elements in own package by default: Even if multiple files with same package exist, 
	 * all elements of the same package are visible in all files. 
	 */
	override List<ImportNormalizer> internalGetImportedNamespaceResolvers(EObject context, boolean ignoreCase) {
		val importedNamespaceResolvers = super.internalGetImportedNamespaceResolvers(context, ignoreCase)
		switch context {
			BPackage:
				addWildcardImportFromSameNamespace(context, importedNamespaceResolvers, ignoreCase)
			BCommandComponentActionParameter:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
			BAssertionComponentActionParameter:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
			BWidgetWrapper:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
			BComboWrapper:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
			BTableWrapper:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
			BTreeWrapper:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
			BTabItemWrapper:
				addNamespace(context, importedNamespaceResolvers, ignoreCase)
		}
		return importedNamespaceResolvers
	}

	def addWildcardImportFromSameNamespace(BPackage bPackage, List<ImportNormalizer> importedNamespaceResolvers,
		boolean ignoreCase) {
		importedNamespaceResolvers.add(
			new ImportNormalizer(qualifiedNameProvider.getFullyQualifiedName(bPackage), true, ignoreCase))
	}

	def void addNamespace(EObject dslObject, List<ImportNormalizer> importedNamespaceResolvers, boolean ignoreCase) {
		val namespaceWidgetContainers = dslObject.getWidgetContainerOfNearestContext
		namespaceWidgetContainers.forEach [
			if (it != null) {
				val qnameToAddImplicitly = qualifiedNameProvider.getFullyQualifiedName(it)
				if (qnameToAddImplicitly != null) {
					importedNamespaceResolvers.add(new ImportNormalizer(qnameToAddImplicitly, true, ignoreCase))
				}
			}
		]
	}

}
