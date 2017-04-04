package org.boomslang.dsl.feature.ui.preference

import org.boomslang.generator.interfaces.IBoomGenerator
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Platform

import static org.boomslang.generator.extensionpoint.BGeneratorContributionHandler.*
import java.util.Map

class FeatureBuilderConfigurationExtension {

	def Map<String, String> allGeneratorExtensions() {
		val registry = Platform.extensionRegistry
		val configs = registry?.getConfigurationElementsFor(IBOOMSLANGFEATUREGENERATOR_ID)
		val generators = <String, String>newHashMap

		generators.put('NONE', 'UNDEFINED')

		if(configs.isNullOrEmpty) return newHashMap('NONE' -> 'UNDEFINED')

		configs.forEach [
			try {
				val candidate = createExecutableExtension(IBoomGeneratorAttributeName) as IBoomGenerator
				val descr = candidate.shortDescription.toString
				val fqn = candidate.class.name
				generators.put(descr, fqn)
			} catch (CoreException ex) {
				ex.printStackTrace // FIXME: do proper exception handing here...
			}
		]

		return generators
	}
}
