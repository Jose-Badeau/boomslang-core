package org.boomslang.core.services

import java.io.File
import java.io.FileInputStream
import java.nio.file.Path
import java.util.Properties
import org.boomslang.core.config.FeatureProperties
import java.io.FileOutputStream

final class PropertiesUtils {

	static String FEATURE_PROPS_FILE_NAME = 'blang-feature.properties'

	def FeatureProperties getFeatureProperties(Path path) {
		return try {
			val propFile = new File(path.toAbsolutePath + File.separator + FEATURE_PROPS_FILE_NAME)
			val is = new FileInputStream(propFile)
			val props = new Properties
			props.load(is)
			new FeatureProperties(props.getProperty('generatorExtensionFQN'))
		} catch (Exception ex) {
			throw new IllegalStateException('Could not load feature properties!', ex)
		}
	}

	def void saveFeatureProperties(FeatureProperties props, Path path) {
		try {
			val propFile = new File(path.toAbsolutePath + File.separator + FEATURE_PROPS_FILE_NAME)
			val fos = new FileOutputStream(propFile)
			new Properties => [
				put('generatorExtensionFQN', props.generatorExtensionFQN)
				store(fos, 'Boomslang Feature Properties')
			]
		} catch (Exception ex) {
			throw new IllegalStateException('Could not store feature properties!', ex)
		}
	}	
}
