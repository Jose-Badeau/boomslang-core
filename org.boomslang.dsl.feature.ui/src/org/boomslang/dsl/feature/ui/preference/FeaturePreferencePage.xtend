package org.boomslang.dsl.feature.ui.preference

import org.boomslang.generator.interfaces.IBoomGenerator
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.preference.ComboFieldEditor
import org.eclipse.xtext.ui.editor.preferences.LanguageRootPreferencePage

import static org.boomslang.generator.extensionpoint.BGeneratorContributionHandler.*
import static org.boomslang.ui.preferences.PreferenceConstants.*

class FeaturePreferencePage extends LanguageRootPreferencePage {
	
	override protected createFieldEditors() {
		super.createFieldEditors // add default editors as well!
		new ComboFieldEditor(
			P_GENERATOR_SWITCH, 'Feature Generator:', allGeneratorExtensions, fieldEditorParent
		) => [addField]
	}
	
	def private String[][] allGeneratorExtensions() {
		val registry = Platform.extensionRegistry
		val configs = registry?.getConfigurationElementsFor(IBOOMSLANGFEATUREGENERATOR_ID)
		val generators = <String, String>newHashMap

		if (configs.isNullOrEmpty) return #[#['NONE', 'UNDEFINED']]

		configs.forEach[
			try {
				val candidate = createExecutableExtension(IBoomGeneratorAttributeName) as IBoomGenerator
				val descr = candidate.shortDescription.toString
				val fqn = candidate.class.name
				generators.put(descr, fqn)
			} catch (CoreException ex) {
				ex.printStackTrace // FIXME: do proper exception handing here...
			}
		]

		return generators.entrySet.map[ e |
			newArrayOfSize(2) => [
				set(0, e.key)
				set(1, e.value)
			]
		]
	}
}