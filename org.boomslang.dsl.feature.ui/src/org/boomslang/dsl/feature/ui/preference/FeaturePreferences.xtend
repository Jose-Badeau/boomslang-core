package org.boomslang.dsl.feature.ui.preference

import com.google.inject.Inject
import org.boomslang.core.services.PropertiesUtils
import org.boomslang.dsl.feature.ui.internal.FeatureActivator
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.jface.preference.IPreferenceStore

final class FeaturePreferences {
	
	private var IPreferenceStore store

	@Inject PropertiesUtils propsUtil

	new() {
		init
	}

	def private void init() {
		store = FeatureActivator.instance.preferenceStore
		propsUtil.getFeatureProperties(null)
//		ResourcesPlugin.workspace.		
	}	
	
}